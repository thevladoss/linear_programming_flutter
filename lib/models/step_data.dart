// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fraction/fraction.dart';

import 'enums.dart';

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

  int getIndexOfBasis() {
    for (StepData step in steps) {
      if (step.basis != null) return steps.indexOf(step);
    }
    return 0;
  }

  int getIndexOfAnswer() {
    for (StepData step in steps) {
      if (step.answer != null) return steps.indexOf(step);
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
      'func': func,
      'matrix': matrix,
      'basis': basis,
      'numberType': numberType.toString().split('.')[1],
      'funcType': funcType.toString().split('.')[1],
      'answerType': answerType.toString().split('.')[1],
      'steps': steps.map((x) => x.toMap()).toList(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      vars: map['vars'] as int,
      limits: map['limits'] as int,
      func: Map<int, String>.from((map['func'] as Map<int, String>)),
      matrix: List<List<String>>.from(
        (map['matrix'] as List<String>).map<String>(
          (x) => x,
        ),
      ),
      basis: List<bool>.from((map['basis'] as List<bool>)),
      numberType: NumberType.values
          .firstWhere((element) => element == map['numberType']),
      funcType:
          FuncType.values.firstWhere((element) => element == map['funcType']),
      answerType: AnswerType.values
          .firstWhere((element) => element == map['answerType']),
      steps: List<StepData>.from(
        (map['steps'] as List<int>).map<StepData>(
          (x) => StepData.fromMap(x as Map<String, dynamic>),
        ),
      ),
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

class StepData {
  final Map<int, Fraction> func;
  final List<List<Fraction>> matrix;
  List<int>? element;
  final List<Fraction>? basis;
  final double? answer;

  StepData({
    required this.func,
    required this.matrix,
    this.element,
    this.basis,
    this.answer,
  });

  StepData copyWith({
    Map<int, Fraction>? func,
    List<List<Fraction>>? matrix,
    List<int>? element,
    List<Fraction>? basis,
    double? answer,
  }) {
    return StepData(
      func: func ?? this.func,
      matrix: matrix ?? this.matrix,
      element: element ?? this.element,
      basis: basis ?? this.basis,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'func': func,
      'matrix': matrix,
      'element': element,
      'basis': basis,
      'answer': answer,
    };
  }

  factory StepData.fromMap(Map<String, dynamic> map) {
    return StepData(
      func: Map<int, Fraction>.from((map['func'] as Map<int, double>)),
      matrix: List<List<Fraction>>.from(
        (map['matrix'] as List<List<Fraction>>).map<List<Fraction>>(
          (x) => x,
        ),
      ),
      element: map['element'] != null
          ? List<int>.from((map['element'] as List<int>))
          : null,
      basis: map['basis'] != null
          ? List<Fraction>.from((map['basis'] as List<Fraction>))
          : null,
      answer: map['answer'] != null ? map['answer'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StepData.fromJson(String source) =>
      StepData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StepData(func: $func, matrix: $matrix, element: $element, basis: $basis, answer: $answer)';
  }

  @override
  bool operator ==(covariant StepData other) {
    if (identical(this, other)) return true;

    return mapEquals(other.func, func) &&
        listEquals(other.matrix, matrix) &&
        listEquals(other.element, element) &&
        listEquals(other.basis, basis) &&
        other.answer == answer;
  }

  @override
  int get hashCode {
    return func.hashCode ^
        matrix.hashCode ^
        element.hashCode ^
        basis.hashCode ^
        answer.hashCode;
  }

  bool isElementSupport(int line, int column) {
    Fraction elementValue = 0.toFraction();
    if (matrix[matrix.length - 1][column] < 0.toFraction()) {
      for (int j = 1; j < matrix.length - 1; j++) {
        if (matrix[j][column].toDouble() > 0) {
          if ((matrix[j][matrix[0].length - 1] / matrix[j][column] <
                      elementValue ||
                  elementValue.toDouble() == 0) &&
              ((basis == null && matrix[j][0].toDouble() > func.length) ||
                  basis != null)) {
            elementValue = matrix[j][matrix[0].length - 1] / matrix[j][column];
          }
        }
      }
      if (((basis == null && matrix[line][0].toDouble() > func.length) ||
              basis != null) &&
          matrix[line][matrix[0].length - 1] / matrix[line][column] ==
              elementValue) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  List<List<int>> getPossibleElements() {
    List<List<int>> ElementList = [];
    for (int i = 1; i < matrix.length - 1; i++) {
      for (int j = 1; j < matrix[0].length - 1; j++) {
        if (isElementSupport(i, j)) {
          ElementList.add([i, j]);
        }
      }
    }
    return ElementList;
  }
}
