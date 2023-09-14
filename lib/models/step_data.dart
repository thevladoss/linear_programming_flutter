// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:fraction/fraction.dart';

import 'number_type.dart';

class StepData {
  final Map<int, double> func;
  final List<List<Fraction>> matrix;
  final int varsCount;
  final List<int>? element;
  final List<Fraction>? basis;
  final double? answer;
  final NumberType type;

  StepData({
    required this.func,
    required this.matrix,
    required this.varsCount,
    this.element,
    this.basis,
    this.answer,
    required this.type,
  });

  StepData copyWith({
    Map<int, double>? func,
    List<List<Fraction>>? matrix,
    int? varsCount,
    List<int>? element,
    List<Fraction>? basis,
    double? answer,
    NumberType? type,
  }) {
    return StepData(
      func: func ?? this.func,
      matrix: matrix ?? this.matrix,
      varsCount: varsCount ?? this.varsCount,
      element: element ?? this.element,
      basis: basis ?? this.basis,
      answer: answer ?? this.answer,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'func': func,
      'matrix': matrix,
      'varsCount': varsCount,
      'element': element,
      'basis': basis,
      'answer': answer,
      'type': type.toString().split('.')[1],
    };
  }

  factory StepData.fromMap(Map<String, dynamic> map) {
    return StepData(
      func: Map<int, double>.from((map['func'] as Map<int, double>)),
      matrix: List<List<Fraction>>.from(
        (map['matrix'] as List<Fraction>).map<Fraction>(
          (x) => x,
        ),
      ),
      varsCount: map['varsCount'] as int,
      element: List<int>.from((map['element'] as List<int>)),
      basis: map['basis'] != null
          ? List<Fraction>.from((map['basis'] as List<Fraction>))
          : null,
      answer: map['answer'] != null ? map['answer'] as double : null,
      type: NumberType.values.firstWhere((element) => element == map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StepData.fromJson(String source) =>
      StepData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StepData(func: $func, matrix: $matrix, varsCount: $varsCount, element: $element, basis: $basis, answer: $answer, type: $type)';
  }

  @override
  bool operator ==(covariant StepData other) {
    if (identical(this, other)) return true;

    return mapEquals(other.func, func) &&
        listEquals(other.matrix, matrix) &&
        other.varsCount == varsCount &&
        listEquals(other.element, element) &&
        listEquals(other.basis, basis) &&
        other.answer == answer &&
        other.type == type;
  }

  @override
  int get hashCode {
    return func.hashCode ^
        matrix.hashCode ^
        varsCount.hashCode ^
        element.hashCode ^
        basis.hashCode ^
        answer.hashCode ^
        type.hashCode;
  }

  bool isElementSupport(int line, int column) {
    Fraction elementValue = 0.toFraction();
    if (matrix[matrix.length - 1][column] < 0.toFraction()) {
      for (int j = 1; j < matrix.length - 1; j++) {
        if (matrix[j][column].toDouble() > 0) {
          if ((matrix[j][matrix[0].length - 1] / matrix[j][column] <
                      elementValue ||
                  elementValue.toDouble() == 0) &&
              ((basis == null && matrix[j][0].toDouble() > varsCount) ||
                  basis != null)) {
            elementValue = matrix[j][matrix[0].length - 1] / matrix[j][column];
          }
        }
      }
      if (((basis == null && matrix[line][0].toDouble() > varsCount) ||
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
