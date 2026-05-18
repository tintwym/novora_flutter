import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

/// Sunrise / sunset for the device timezone (local wall clock).
///
/// Previously used Greenwich only, which inverted day/night for users in other
/// regions (e.g. morning in UTC+8 while GMT was still nighttime → dark theme).
abstract final class DaylightSchedule {
  /// Approximate coordinates from [timeZoneOffset] when no preset matches.
  static (double lat, double lon) coordsForOffset(Duration offset) {
    final h = offset.inHours;
    return switch (h) {
      8 => (3.139, 101.6869), // Malaysia (MYT)
      7 => (13.7563, 100.5018), // Thailand
      0 => (51.4769, 0.0), // UK / GMT
      1 => (48.8566, 2.3522), // CET (Paris)
      -5 => (40.7128, -74.006), // US Eastern
      -8 => (34.0522, -118.2437), // US Pacific
      _ => (20.0, h * 15.0),
    };
  }

  static SunriseSunsetResult forDate(DateTime localDate) {
    final day = DateTime(localDate.year, localDate.month, localDate.day);
    final (lat, lon) = coordsForOffset(localDate.timeZoneOffset);
    return getSunriseSunset(lat, lon, localDate.timeZoneOffset, day);
  }

  static int _minutesOfDay(DateTime t) => t.hour * 60 + t.minute;

  /// Whether [localNow] is between today's sunrise and sunset (local wall clock).
  ///
  /// The sunrise package stores clock times on UTC [DateTime] values; compare
  /// hour/minute only, not absolute instants.
  static bool isDaytime(DateTime localNow) {
    final times = forDate(localNow);
    final now = _minutesOfDay(localNow);
    final rise = _minutesOfDay(times.sunrise);
    final set = _minutesOfDay(times.sunset);
    return now >= rise && now < set;
  }

  static DateTime _onDate(DateTime date, DateTime time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  /// Next theme transition moment in local time.
  static DateTime nextTransition(DateTime localNow) {
    final today = forDate(localNow);
    final now = _minutesOfDay(localNow);
    final rise = _minutesOfDay(today.sunrise);
    final set = _minutesOfDay(today.sunset);

    if (now < rise) {
      return _onDate(localNow, today.sunrise);
    }
    if (now < set) {
      return _onDate(localNow, today.sunset);
    }

    final tomorrow = DateTime(localNow.year, localNow.month, localNow.day)
        .add(const Duration(days: 1));
    return _onDate(tomorrow, forDate(tomorrow).sunrise);
  }
}
