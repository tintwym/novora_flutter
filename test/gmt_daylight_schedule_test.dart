import 'package:flutter_test/flutter_test.dart';
import 'package:novora_flutter/core/theme/gmt_daylight_schedule.dart';

void main() {
  test('sunrise is before sunset for a summer day in Greenwich', () {
    final times = GmtDaylightSchedule.forDate(DateTime.utc(2025, 6, 21));
    expect(times.sunrise.isBefore(times.sunset), isTrue);
    expect(times.sunrise.isUtc, isTrue);
    expect(times.sunset.isUtc, isTrue);
  });

  test('noon UTC in June is daytime', () {
    expect(
      GmtDaylightSchedule.isDaytimeUtc(DateTime.utc(2025, 6, 21, 12)),
      isTrue,
    );
  });

  test('midnight UTC in June is nighttime', () {
    expect(
      GmtDaylightSchedule.isDaytimeUtc(DateTime.utc(2025, 6, 21, 0)),
      isFalse,
    );
  });
}
