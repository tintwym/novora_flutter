import 'dart:async';

import 'package:flutter/material.dart';

import 'daylight_schedule.dart';

/// Switches between light and dark theme at local sunrise and sunset.
class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  ThemeNotifier._();

  static final ThemeNotifier instance = ThemeNotifier._();

  Timer? _timer;
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  /// Human-readable summary for debugging / optional UI.
  String get scheduleLabel => 'Local sunrise & sunset';

  Future<void> load() async {
    WidgetsBinding.instance.addObserver(this);
    refresh();
  }

  void refresh() {
    _applyForNow();
    _scheduleNextTransition();
  }

  void _applyForNow() {
    final now = DateTime.now();
    final next = DaylightSchedule.isDaytime(now)
        ? ThemeMode.light
        : ThemeMode.dark;
    if (next != _mode) {
      _mode = next;
      notifyListeners();
    }
  }

  void _scheduleNextTransition() {
    _timer?.cancel();
    final now = DateTime.now();
    final at = DaylightSchedule.nextTransition(now);
    var delay = at.difference(now);
    if (delay.isNegative) {
      delay = Duration.zero;
    } else {
      delay += const Duration(seconds: 1);
    }
    _timer = Timer(delay, () {
      _applyForNow();
      _scheduleNextTransition();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  void disposeScheduler() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}
