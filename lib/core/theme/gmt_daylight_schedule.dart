import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

/// Sunrise / sunset for [Greenwich] (GMT reference). Times are UTC.
abstract final class GmtDaylightSchedule {
  /// Royal Observatory, Greenwich — used as the GMT/UTC daylight reference.
  static const double latitude = 51.4769;
  static const double longitude = 0.0;

  static const Duration utcOffset = Duration.zero;

  static SunriseSunsetResult forDate(DateTime utcDate) {
    final day = DateTime.utc(utcDate.year, utcDate.month, utcDate.day);
    return getSunriseSunset(latitude, longitude, utcOffset, day);
  }

  static bool isDaytimeUtc(DateTime utcNow) {
    final times = forDate(utcNow);
    return !utcNow.isBefore(times.sunrise) && utcNow.isBefore(times.sunset);
  }

  /// Next moment the theme should change (sunrise or sunset), in UTC.
  static DateTime nextTransitionUtc(DateTime utcNow) {
    final today = forDate(utcNow);

    if (utcNow.isBefore(today.sunrise)) {
      return today.sunrise;
    }
    if (utcNow.isBefore(today.sunset)) {
      return today.sunset;
    }

    final tomorrow = DateTime.utc(utcNow.year, utcNow.month, utcNow.day)
        .add(const Duration(days: 1));
    return forDate(tomorrow).sunrise;
  }
}
