import 'package:flutter/material.dart';

/// Slice for attendance breakdown charts.
class AttendanceSliceModel {
  const AttendanceSliceModel({
    required this.label,
    required this.value,
    required this.displayPercent,
    required this.color,
  });

  final String label;
  final double value;
  final String displayPercent;
  final Color color;
}
