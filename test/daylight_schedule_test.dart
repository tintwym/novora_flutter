import 'package:flutter_test/flutter_test.dart';
import 'package:novora_flutter/core/theme/daylight_schedule.dart';

void main() {
  test('sunrise is before sunset for a summer day (Malaysia)', () {
    final local = DateTime(2025, 6, 21);
    final times = DaylightSchedule.forDate(local);
    expect(times.sunrise.isBefore(times.sunset), isTrue);
  });

  test('noon local in June is daytime', () {
    expect(
      DaylightSchedule.isDaytime(DateTime(2025, 6, 21, 12)),
      isTrue,
    );
  });

  test('midnight local in June is nighttime', () {
    expect(
      DaylightSchedule.isDaytime(DateTime(2025, 6, 21, 0)),
      isFalse,
    );
  });

  test('early morning after sunrise is daytime', () {
    final times = DaylightSchedule.forDate(DateTime(2025, 6, 21));
    final afterSunrise = DateTime(
      2025,
      6,
      21,
      times.sunrise.hour,
      times.sunrise.minute + 30,
    );
    expect(DaylightSchedule.isDaytime(afterSunrise), isTrue);
  });
}
