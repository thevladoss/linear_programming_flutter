import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linear_flutter/main_page.dart';

import 'models/number_type.dart';
import 'models/step_data.dart';

void main() {
  // runApp(const MainApp());
  print(step(StepData(matrix: [
    [0, 1, 2, 3, 4, 5, 0],
    [6, -2, 4, 1, -1, 0, 3],
    [7, 4, -3, -1, 1, 1, 6],
    [8, 1, 4, 1, 0, 1, 15],
    [0, -3, -5, -1, 0, -2, -24]
  ], element: [
    1,
    2
  ], type: NumberType.decimal)));
}

StepData step(StepData previousData) {
  StepData nextData = previousData.copyWith();
  nextData.matrix[0][0] += 1;
  double swap = nextData.matrix[0][nextData.element[1]];
  nextData.matrix[0][nextData.element[1]] =
      nextData.matrix[nextData.element[0]][0];
  nextData.matrix[nextData.element[0]][0] = swap;
  nextData.matrix[nextData.element[0]][nextData.element[1]] =
      1 / nextData.matrix[nextData.element[0]][nextData.element[1]];
  for (int i = 1; i < nextData.matrix[nextData.element[0]].length; i++) {
    if (i != nextData.element[1]) {
      nextData.matrix[nextData.element[0]][i] *=
          nextData.matrix[nextData.element[0]][nextData.element[1]];
    }
  }
  for (int x = 1; x < nextData.matrix.length; x++) {
    for (int y = 1; y < nextData.matrix[x].length; y++) {
      if (x != nextData.element[0] && y != nextData.element[1]) {
        nextData.matrix[x][y] -= nextData.matrix[x][nextData.element[1]] *
            nextData.matrix[nextData.element[0]][y];
      }
    }
  }
  for (int i = 1; i < nextData.matrix.length; i++) {
    if (i != nextData.element[0]) {
      nextData.matrix[i][nextData.element[1]] *=
          -1 * nextData.matrix[nextData.element[0]][nextData.element[1]];
    }
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
