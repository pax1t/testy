
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:testy/models/models.dart';

void main() {
  group('SunData test', () {
    test('sunrise decode', () {
      final now = DateTime.now();
      final data = '''
        {
          "results": {
            "sunrise": "${now.toIso8601String()}",
            "sunset": "${now.add(Duration(hours: 5)).toIso8601String()}",
            "day_length": ${Duration(hours: 5).inSeconds}
          },
          "status": "OK"
        }
      ''';

      final sunData = SunData.fromJson(json.decode(data)["results"]);

      expect(sunData.sunrise.millisecondsSinceEpoch, now.millisecondsSinceEpoch);
      expect(sunData.sunset.difference(sunData.sunrise).inHours, 5);
      expect(sunData.dayLength, Duration(hours: 5).inSeconds);
      expect(sunData.daylight, Duration(hours: 5).inSeconds);
    });

  });
}