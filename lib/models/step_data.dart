// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'number_type.dart';

class StepData {
  final Map<int, double> func;
  final List<List<double>> matrix;
  final int varsCount;
  final List<int>? element;
  final List<double>? basis;
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
    List<List<double>>? matrix,
    int? varsCount,
    List<int>? element,
    List<double>? basis,
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
      matrix: List<List<double>>.from(
        (map['matrix'] as List<double>).map<double>(
          (x) => x,
        ),
      ),
      varsCount: map['varsCount'] as int,
      element: List<int>.from((map['element'] as List<int>)),
      basis: map['basis'] != null
          ? List<double>.from((map['basis'] as List<double>))
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

  List<List<int>> getPossibleElements() {
    List<List<int>> ElementList = [];
    double elementValue = 0;
    for (int i = element![1]; i < matrix[0].length - 1; i++) {
      if (matrix[matrix.length - 1][i] < 0) {
        for (int j = 1; j < matrix.length - 1; j++) {
          if ((matrix[j][matrix[0].length - 1] / matrix[j][i] < elementValue &&
                  matrix[j][i] >= 0) ||
              (elementValue == 0 && matrix[j][i] >= 0)) {
            elementValue = matrix[j][matrix[0].length - 1] / matrix[j][i];
            ElementList.add([j, i]);
          }
        }
      }
    }
    if (ElementList.length > 0) {
      ElementList.removeAt(0);
    }
    return ElementList;
  }
}
