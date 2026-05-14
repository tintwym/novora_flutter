import 'package:flutter/material.dart';

/// One wedge for the department distribution chart.
class DepartmentSliceModel {
  const DepartmentSliceModel({
    required this.name,
    required this.value,
    required this.count,
    required this.color,
  });

  final String name;
  final double value;
  final int count;
  final Color color;
}
