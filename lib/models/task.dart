import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'enums.dart';
import 'step_data.dart';

class Task {
  int vars;
  int limits;
  Map<int, String> func;
  List<List<String>> matrix;
  List<bool> basis;
  NumberType numberType;
  FuncType funcType;
  AnswerType answerType;
  final List<StepData> steps;

  Task({
    required this.vars,
    required this.limits,
    required this.func,
    required this.matrix,
    required this.basis,
    required this.numberType,
    required this.funcType,
    required this.answerType,
    required this.steps,
  });

  addStep(StepData step) {
    steps.add(step);
  }

  removeStep(int i, int j) {
    steps.removeRange(i, j);
  }

  clear() {
    steps.clear();
  }

  bool isBasisOnStart() {
    for (StepData step in steps) {
      if (step.basis == null) return false;
    }
    if (steps.isEmpty) return false;
    return true;
  }

  bool isAnswerExist() {
    for (StepData step in steps) {
      if (step.isAnswerExist == false) return false;
    }
    if (steps.isEmpty) return true;
    return true;
  }

  int getIndexOfBasis() {
    for (StepData step in steps) {
      if (step.basis != null) return steps.indexOf(step);
    }
    return 0;
  }

  int getIndexOfAnswer() {
    for (StepData step in steps) {
      if (step.answer != null) return steps.indexOf(step);
      if (step.isAnswerExist == false) return steps.indexOf(step);
    }
    return 0;
  }

  Task copyWith({
    int? vars,
    int? limits,
    Map<int, String>? func,
    List<List<String>>? matrix,
    List<bool>? basis,
    NumberType? numberType,
    FuncType? funcType,
    AnswerType? answerType,
    List<StepData>? steps,
  }) {
    return Task(
      vars: vars ?? this.vars,
      limits: limits ?? this.limits,
      func: func ?? this.func,
      matrix: matrix ?? this.matrix,
      basis: basis ?? this.basis,
      numberType: numberType ?? this.numberType,
      funcType: funcType ?? this.funcType,
      answerType: answerType ?? this.answerType,
      steps: steps ?? this.steps,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'vars': vars,
      'limits': limits,
      'func': {for (int k in func.keys) k.toString(): func[k]},
      'matrix': matrix,
      'basis': basis,
      'numberType': numberType.toString().split('.')[1],
      'funcType': funcType.toString().split('.')[1],
      'answerType': answerType.toString().split('.')[1],
      'steps': steps.map((x) => x.toMap()).toList(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    Map<int, String> newFunc = {};
    for (String k in map['func'].keys) {
      newFunc.addAll({int.parse(k): map['func'][k].toString()});
    }

    List<List<String>> newMatrix = [];
    for (List<dynamic> l in map['matrix']) {
      List<String> newLine = [];
      for (dynamic i in l) {
        newLine.add(i.toString());
      }
      newMatrix.add(newLine);
    }

    List<bool> newBasis = [];
    for (dynamic l in map['basis']) {
      newBasis.add(l);
    }

    List<StepData> newSteps = [];
    for (dynamic l in map['steps']) {
      newSteps.add(StepData.fromMap(l));
    }

    return Task(
      vars: map['vars'] as int,
      limits: map['limits'] as int,
      func: newFunc,
      matrix: newMatrix,
      basis: newBasis,
      numberType: NumberType.values.firstWhere(
          (element) => element.toString() == 'NumberType.${map['numberType']}'),
      funcType: FuncType.values.firstWhere(
          (element) => element.toString() == 'FuncType.${map['funcType']}'),
      answerType: AnswerType.values.firstWhere(
          (element) => element.toString() == 'AnswerType.${map['answerType']}'),
      steps: newSteps,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(vars: $vars, limits: $limits, func: $func, matrix: $matrix, basis: $basis, numberType: $numberType, funcType: $funcType, answerType: $answerType, steps: $steps)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.vars == vars &&
        other.limits == limits &&
        mapEquals(other.func, func) &&
        listEquals(other.matrix, matrix) &&
        listEquals(other.basis, basis) &&
        other.numberType == numberType &&
        other.funcType == funcType &&
        other.answerType == answerType &&
        listEquals(other.steps, steps);
  }

  @override
  int get hashCode {
    return vars.hashCode ^
        limits.hashCode ^
        func.hashCode ^
        matrix.hashCode ^
        basis.hashCode ^
        numberType.hashCode ^
        funcType.hashCode ^
        answerType.hashCode ^
        steps.hashCode;
  }
}
