import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'models/step_data.dart';
import 'pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1000, 500));
    WindowManager.instance.setTitle('Linear solver');
  }
  runApp(const MainApp());
  // print(step(StepData(func: {
  //   1: -5,
  //   2: -4,
  //   3: -3,
  //   4: -2,
  //   5: 3
  // }, matrix: [
  //   [0, 1, 2, 3, 4, 5, 0],
  //   [6, 2, 1, 1, 1, -1, 3],
  //   [7, 1, -1, 0, 1, 1, 1],
  //   [8, -2, -1, -1, 1, 0, 1],
  // ], varsCount: 5, type: NumberType.decimal)));
}

StepData step(StepData previousData) {
  StepData nextData = previousData.copyWith();
  if (nextData.matrix[nextData.matrix.length - 1]
              [nextData.matrix[0].length - 1] ==
          0 &&
      nextData.matrix[nextData.matrix.length - 1][0] == 0) {
    if (nextData.basis == null) {
      nextData = nextData.copyWith(basis: []);
      for (int i = 1; i <= nextData.varsCount; i++) {
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          if (nextData.matrix[j][0] == i) {
            nextData.basis!
                .add(nextData.matrix[j][nextData.matrix[0].length - 1]);
            break;
          }
          if (j == nextData.matrix.length - 2) {
            nextData.basis!.add(0);
          }
        }
      }
    }
    for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
      nextData.matrix[nextData.matrix.length - 1][i] += nextData.func.entries
          .firstWhere((entry) => entry.key == nextData.matrix[0][i].toInt())
          .value;
    }

    print(nextData);
    for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
      for (int j = 1; j < nextData.matrix.length - 1; j++) {
        print(nextData.matrix[i][0].toInt());
        nextData.matrix[nextData.matrix.length - 1][j] += -1 *
            nextData.matrix[i][j] *
            nextData.func.entries
                .firstWhere(
                    (entry) => entry.key == nextData.matrix[i][0].toInt())
                .value;
      }
    }
    for (int i = 1; i < nextData.matrix.length - 1; i++) {
      nextData.matrix[nextData.matrix.length - 1]
              [nextData.matrix[0].length - 1] +=
          -1 *
              nextData.matrix[i][nextData.matrix[0].length - 1] *
              nextData.func.entries
                  .firstWhere(
                      (entry) => entry.key == nextData.matrix[i][0].toInt())
                  .value;
    }
    nextData.matrix[0][0] = 0;
  } else {
    if (nextData.matrix[nextData.matrix.length - 1][0] != 0) {
      nextData.matrix.add([0]);
      for (int i = 1; i < nextData.matrix[0].length; i++) {
        double sum = 0;
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          sum += nextData.matrix[j][i];
        }
        nextData.matrix[nextData.matrix.length - 1].add(-1 * sum);
      }
    } else {
      nextData.matrix[0][0] += 1;
      double swap = nextData.matrix[0][nextData.element![1]];
      nextData.matrix[0][nextData.element![1]] =
          nextData.matrix[nextData.element![0]][0];
      nextData.matrix[nextData.element![0]][0] = swap;
      nextData.matrix[nextData.element![0]][nextData.element![1]] =
          1 / nextData.matrix[nextData.element![0]][nextData.element![1]];
      for (int i = 1; i < nextData.matrix[nextData.element![0]].length; i++) {
        if (i != nextData.element![1]) {
          nextData.matrix[nextData.element![0]][i] *=
              nextData.matrix[nextData.element![0]][nextData.element![1]];
        }
      }
      for (int x = 1; x < nextData.matrix.length; x++) {
        for (int y = 1; y < nextData.matrix[x].length; y++) {
          if (x != nextData.element![0] && y != nextData.element![1]) {
            nextData.matrix[x][y] -= nextData.matrix[x][nextData.element![1]] *
                nextData.matrix[nextData.element![0]][y];
          }
        }
      }
      for (int i = 1; i < nextData.matrix.length; i++) {
        if (i != nextData.element![0]) {
          nextData.matrix[i][nextData.element![1]] *=
              -1 * nextData.matrix[nextData.element![0]][nextData.element![1]];
        }
      }
      for (int i = 1; i < nextData.matrix[0].length; i++) {
        if (nextData.matrix[0][i] > nextData.varsCount) {
          for (int j = 0; j < nextData.matrix.length; j++) {
            nextData.matrix[j].removeAt(i);
          }
          break;
        }
      }
    }
    for (int i = 1; i < nextData.matrix[0].length; i++) {
      if (nextData.matrix[nextData.matrix.length - 1][i] < 0) {
        break;
      }
      if (i == nextData.matrix[0].length - 1) {
        nextData = nextData.copyWith(
            answer: -1 * nextData.matrix[nextData.matrix.length - 1][i]);
      }
    }
    double elementValue = 0;
    nextData = nextData.copyWith(element: [0, 0]);
    if (nextData.basis != null) {
      for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
        if (nextData.matrix[nextData.matrix.length - 1][i] < 0) {
          for (int j = 1; j < nextData.matrix.length - 1; j++) {
            if ((nextData.matrix[j][nextData.matrix[0].length - 1] /
                            nextData.matrix[j][i] <
                        elementValue &&
                    nextData.matrix[j][i] >= 0) ||
                (elementValue == 0 && nextData.matrix[j][i] >= 0)) {
              elementValue = nextData.matrix[j][nextData.matrix[0].length - 1] /
                  nextData.matrix[j][i];
              nextData.element![0] = j;
              nextData.element![1] = i;
            }
          }
          break;
        }
      }
    } else {
      for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
        if (nextData.matrix[nextData.matrix.length - 1][i] < 0) {
          for (int j = 1; j < nextData.matrix.length - 1; j++) {
            if (((nextData.matrix[j][nextData.matrix[0].length - 1] /
                            nextData.matrix[j][i] <
                        elementValue &&
                    nextData.matrix[j][i] >= 0 &&
                    nextData.matrix[j][0].toInt() > nextData.varsCount) ||
                (elementValue == 0 &&
                    nextData.matrix[j][i] >= 0 &&
                    nextData.matrix[j][0].toInt() > nextData.varsCount))) {
              print(nextData.matrix[j][0].toInt());
              elementValue = nextData.matrix[j][nextData.matrix[0].length - 1] /
                  nextData.matrix[j][i];
              nextData.element![0] = j;
              nextData.element![1] = i;
            }
          }
          break;
        }
      }
    }
  }
  print(nextData.getPossibleElements());
  print(nextData);
  // if (nextData.answer == null) {
  //   nextData = step(nextData);
  // }
  return nextData;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: MainPage(),
    );
  }
}
