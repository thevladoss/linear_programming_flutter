// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'number_type.dart';

class StepData {
  final List<List<double>> matrix;
  final List<int> element;
  final List<double>? basis;
  final NumberType type;
  StepData({
    required this.matrix,
    required this.element,
    this.basis,
    required this.type,
  });

  StepData copyWith({
    List<List<double>>? matrix,
    List<int>? element,
    List<double>? basis,
    NumberType? type,
  }) {
    return StepData(
      matrix: matrix ?? this.matrix,
      element: element ?? this.element,
      basis: basis ?? this.basis,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matrix': matrix,
      'element': element,
      'basis': basis,
      'type': type.toString().split('.')[1],
    };
  }

  factory StepData.fromMap(Map<String, dynamic> map) {
    return StepData(
      matrix: List<List<double>>.from((map['matrix'] as List<List<double>>)),
      element: List<int>.from((map['element'] as List<int>)),
      basis: map['basis'] != null
          ? List<double>.from((map['basis'] as List<double>))
          : null,
      type: NumberType.values.firstWhere((element) => element == map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StepData.fromJson(String source) =>
      StepData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StepData(matrix: $matrix, element: $element, basis: $basis, type: $type)';
  }

  @override
  bool operator ==(covariant StepData other) {
    if (identical(this, other)) return true;

    return listEquals(other.matrix, matrix) &&
        listEquals(other.element, element) &&
        listEquals(other.basis, basis) &&
        other.type == type;
  }

  @override
  int get hashCode {
    return matrix.hashCode ^ element.hashCode ^ basis.hashCode ^ type.hashCode;
  }
}
