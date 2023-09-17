// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fraction/fraction.dart';

import 'enums.dart';

class StepData {
  final Map<int, Fraction> func;
  final List<List<Fraction>> matrix;
  final List<int>? element;
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
    int? varsCount,
    List<int>? element,
    List<Fraction>? basis,
    double? answer,
    NumberType? type,
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
        (map['matrix'] as List<Fraction>).map<Fraction>(
          (x) => x,
        ),
      ),
      element: List<int>.from((map['element'] as List<int>)),
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
