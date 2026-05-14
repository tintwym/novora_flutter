import 'package:flutter/material.dart';

class LeaveRequestModel {
  const LeaveRequestModel({
    required this.name,
    required this.type,
    required this.dates,
    required this.status,
    required this.initials,
    required this.color,
  });

  final String name;
  final String type;
  final String dates;
  final String status;
  final String initials;
  final Color color;
}
