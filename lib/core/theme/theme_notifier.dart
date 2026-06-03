import 'dart:async';

import 'package:flutter/material.dart';

import '../storage/local_storage.dart';
import 'daylight_schedule.dart';

/// User's choice for how dark mode is decided.
enum ThemePreference {
  /// Follow local sunrise / sunset (original behaviour).
  auto,
  light,
  dark,
}

/// Resolves [ThemeMode] from a [ThemePreference] + (in `auto`) local sunrise/sunset.
///
/// On `auto` it schedules timers at the next sunrise / sunset so the app
/// flips without a manual reload. On `light`/`dark` the timer is cancelled.
class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  ThemeNotifier._();

  static final ThemeNotifier instance = ThemeNotifier._();

  Timer? _timer;
  ThemeMode _mode = ThemeMode.light;
  ThemePreference _preference = ThemePreference.auto;

  ThemeMode get mode => _mode;

  ThemePreference get preference => _preference;

  String get scheduleLabel => switch (_preference) {
    ThemePreference.auto => 'Local sunrise & sunset',
    ThemePreference.light => 'Always light',
    ThemePreference.dark => 'Always dark',
  };

  Future<void> load() async {
    WidgetsBinding.instance.addObserver(this);
    _preference = _readPreference();
    refresh();
  }

  /// Persist a new preference and re-apply immediately.
  Future<void> setPreference(ThemePreference p) async {
    if (_preference == p) return;
    _preference = p;
    try {
      LocalStorage.instance.themePreference = _writePreference(p);
    } catch (_) {
      // LocalStorage not initialised yet (tests / early bootstrap) — keep the
      // in-memory value so the UI still reflects the toggle.
    }
    refresh();
  }

  void refresh() {
    _applyForNow();
    _scheduleNextTransition();
  }

  void _applyForNow() {
    final next = switch (_preference) {
      ThemePreference.light => ThemeMode.light,
      ThemePreference.dark => ThemeMode.dark,
      ThemePreference.auto => DaylightSchedule.isDaytime(DateTime.now())
          ? ThemeMode.light
          : ThemeMode.dark,
    };
    if (next != _mode) {
      _mode = next;
      notifyListeners();
    }
  }

  void _scheduleNextTransition() {
    _timer?.cancel();
    if (_preference != ThemePreference.auto) {
      // Manual override — no timer needed. Cancelling avoids waking the device
      // to flip a theme the user has explicitly pinned.
      return;
    }
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

  static ThemePreference _readPreference() {
    try {
      return switch (LocalStorage.instance.themePreference) {
        'light' => ThemePreference.light,
        'dark' => ThemePreference.dark,
        _ => ThemePreference.auto,
      };
    } catch (_) {
      // Storage not initialised yet — fall back to auto.
      return ThemePreference.auto;
    }
  }

  static String _writePreference(ThemePreference p) => switch (p) {
    ThemePreference.light => 'light',
    ThemePreference.dark => 'dark',
    ThemePreference.auto => 'auto',
  };
}
