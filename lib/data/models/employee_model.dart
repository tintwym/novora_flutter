import 'package:flutter/material.dart';

class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.fullName,
    required this.roleTitle,
    this.department,
    this.hireDate,
  });

  final String id;
  final String fullName;
  final String roleTitle;
  final String? department;
  final DateTime? hireDate;
}

/// Row shown in “Recent hires” dashboard card.
class RecentHireModel {
  const RecentHireModel({
    required this.name,
    required this.role,
    required this.date,
    required this.initials,
    required this.color,
  });

  final String name;
  final String role;
  final String date;
  final String initials;
  final Color color;
}
