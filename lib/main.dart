import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:linear_flutter/main_page.dart';

import 'models/number_type.dart';
import 'models/step_data.dart';

void main() {
  // runApp(const MainApp());
  print(step(StepData(func: {
    1: -5,
    2: -4,
    3: -3,
    4: -2,
    5: 3
  }, matrix: [
    [
      0.toFraction(),
      1.toFraction(),
      2.toFraction(),
      3.toFraction(),
      4.toFraction(),
      5.toFraction(),
      0.toFraction()
    ],
    [
      6.toFraction(),
      2.toFraction(),
      1.toFraction(),
      1.toFraction(),
      1.toFraction(),
      (-1).toFraction(),
      3.toFraction()
    ],
    [
      7.toFraction(),
      1.toFraction(),
      (-1).toFraction(),
      0.toFraction(),
      1.toFraction(),
      1.toFraction(),
      1.toFraction()
    ],
    [
      8.toFraction(),
      (-2).toFraction(),
      (-1).toFraction(),
      (-1).toFraction(),
      1.toFraction(),
      0.toFraction(),
      1.toFraction()
    ],
  ], varsCount: 5, type: NumberType.fraction)));
}

StepData step(StepData previousData) {
  StepData nextData = previousData.copyWith();
  if (nextData.matrix[nextData.matrix.length - 1][nextData.matrix[0].length - 1]
              .toDouble() ==
          0 &&
      nextData.matrix[nextData.matrix.length - 1][0].toDouble() == 0) {
    if (nextData.basis == null) {
      nextData = nextData.copyWith(basis: []);
      for (int i = 1; i <= nextData.varsCount; i++) {
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          if (nextData.matrix[j][0].toDouble() == i) {
            nextData.basis!.add(
                nextData.matrix[j][nextData.matrix[0].length - 1].reduce());
            break;
          }
          if (j == nextData.matrix.length - 2) {
            nextData.basis!.add(0.toFraction());
          }
        }
      }
    }
    for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
      nextData.matrix[nextData.matrix.length - 1][i] += nextData.func.entries
          .firstWhere(
              (entry) => entry.key == nextData.matrix[0][i].toDouble().toInt())
          .value
          .toFraction();
    }

    for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
      for (int j = 1; j < nextData.matrix.length - 1; j++) {
        nextData.matrix[nextData.matrix.length - 1][i] += (-1).toFraction() *
            nextData.matrix[j][i] *
            nextData.func.entries
                .firstWhere((entry) =>
                    entry.key == nextData.matrix[j][0].toDouble().toInt())
                .value
                .toFraction();
      }
      nextData.matrix[nextData.matrix.length - 1][i] =
          nextData.matrix[nextData.matrix.length - 1][i].reduce();
    }
    for (int i = 1; i < nextData.matrix.length - 1; i++) {
      nextData.matrix[nextData.matrix.length - 1]
              [nextData.matrix[0].length - 1] +=
          (-1).toFraction() *
              nextData.matrix[i][nextData.matrix[0].length - 1] *
              nextData.func.entries
                  .firstWhere((entry) =>
                      entry.key == nextData.matrix[i][0].toDouble().toInt())
                  .value
                  .toFraction();
    }
    nextData.matrix[0][0] = 0.toFraction();
  } else {
    if (nextData.matrix[nextData.matrix.length - 1][0].toDouble() != 0) {
      nextData.matrix.add([0.toFraction()]);
      for (int i = 1; i < nextData.matrix[0].length; i++) {
        Fraction sum = 0.toFraction();
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          sum += nextData.matrix[j][i];
        }
        nextData.matrix[nextData.matrix.length - 1]
            .add((-1).toFraction() * sum);
      }
    } else {
      nextData.matrix[0][0] += 1.toFraction();
      Fraction swap = nextData.matrix[0][nextData.element![1]];
      nextData.matrix[0][nextData.element![1]] =
          nextData.matrix[nextData.element![0]][0];
      nextData.matrix[nextData.element![0]][0] = swap;
      nextData.matrix[nextData.element![0]][nextData.element![1]] =
          nextData.matrix[nextData.element![0]][nextData.element![1]].inverse();
      for (int i = 1; i < nextData.matrix[nextData.element![0]].length; i++) {
        if (i != nextData.element![1]) {
          nextData.matrix[nextData.element![0]][i] *=
              nextData.matrix[nextData.element![0]][nextData.element![1]];
        }
        nextData.matrix[nextData.element![0]][i] =
            nextData.matrix[nextData.element![0]][i].reduce();
      }
      for (int x = 1; x < nextData.matrix.length; x++) {
        for (int y = 1; y < nextData.matrix[x].length; y++) {
          if (x != nextData.element![0] && y != nextData.element![1]) {
            nextData.matrix[x][y] -= nextData.matrix[x][nextData.element![1]] *
                nextData.matrix[nextData.element![0]][y];
            nextData.matrix[x][y] = nextData.matrix[x][y].reduce();
          }
        }
      }
      for (int i = 1; i < nextData.matrix.length; i++) {
        if (i != nextData.element![0]) {
          nextData.matrix[i][nextData.element![1]] *= (-1).toFraction() *
              nextData.matrix[nextData.element![0]][nextData.element![1]];
        }
        nextData.matrix[i][nextData.element![1]] =
            nextData.matrix[i][nextData.element![1]].reduce();
      }
      for (int i = 1; i < nextData.matrix[0].length; i++) {
        if (nextData.matrix[0][i].toDouble() > nextData.varsCount) {
          for (int j = 0; j < nextData.matrix.length; j++) {
            nextData.matrix[j].removeAt(i);
          }
          break;
        }
      }
    }
  }
  Fraction elementValue = 0.toFraction();
  nextData = nextData.copyWith(element: [0, 0]);
  if (nextData.basis != null) {
    for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
      if (nextData.matrix[nextData.matrix.length - 1][i].toDouble() < 0) {
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          if (nextData.matrix[j][i].toDouble() > 0) {
            if ((nextData.matrix[j][nextData.matrix[0].length - 1] /
                            nextData.matrix[j][i] <
                        elementValue &&
                    nextData.matrix[j][i] >= 0.toFraction()) ||
                (elementValue.toDouble() == 0 &&
                    nextData.matrix[j][i].toDouble() >= 0)) {
              elementValue = nextData.matrix[j][nextData.matrix[0].length - 1] /
                  nextData.matrix[j][i];
              nextData.element![0] = j;
              nextData.element![1] = i;
            }
          }
        }
      }
    }
  } else {
    for (int i = 1; i < nextData.matrix[0].length - 1; i++) {
      if (nextData.matrix[nextData.matrix.length - 1][i].toDouble() < 0) {
        for (int j = 1; j < nextData.matrix.length - 1; j++) {
          if (nextData.matrix[j][i].toDouble() != 0) {
            if (((nextData.matrix[j][nextData.matrix[0].length - 1] /
                            nextData.matrix[j][i] <
                        elementValue &&
                    nextData.matrix[j][i] >= 0.toFraction() &&
                    nextData.matrix[j][0].toDouble() > nextData.varsCount) ||
                (elementValue == 0.toFraction() &&
                    nextData.matrix[j][i] >= 0.toFraction() &&
                    nextData.matrix[j][0].toDouble() > nextData.varsCount))) {
              elementValue = nextData.matrix[j][nextData.matrix[0].length - 1] /
                  nextData.matrix[j][i];
              nextData.element![0] = j;
              nextData.element![1] = i;
            }
          }
        }
        break;
      }
    }
  }
  for (int i = 1; i < nextData.matrix[0].length; i++) {
    if (nextData.matrix[nextData.matrix.length - 1][i] < 0.toFraction() ||
        nextData.basis == null) {
      break;
    }
    if (i == nextData.matrix[0].length - 1) {
      nextData = nextData.copyWith(
          answer:
              -1 * nextData.matrix[nextData.matrix.length - 1][i].toDouble());
    }
  }

  print(nextData);
  print(nextData.getPossibleElements());
  if (nextData.answer == null) {
    nextData = step(nextData);
  }
  return nextData;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: MainPage());
  }
}
