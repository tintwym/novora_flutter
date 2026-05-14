import 'package:flutter/material.dart';

String formatDisplayDate(DateTime d, BuildContext context) {
  return MaterialLocalizations.of(context).formatFullDate(d);
}
