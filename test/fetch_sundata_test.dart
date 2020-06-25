import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:testy/sundata.dart';

class MockClient extends Mock implements http.Client {}

void main () {
  group('Fetch SunData', () {
    test('fetch SunData from API', () async {
      final client = MockClient();
      final String mockData = '{"results":{'
          '"sunrise":"2020-06-25T05:00:33+00:00",'
          '"sunset":"2020-06-25T19:40:33+00:00",'
          '"solar_noon":"2020-06-25T12:20:33+00:00",'
          '"day_length":52800,'
          '"civil_twilight_begin":"2020-06-25T04:29:58+00:00",'
          '"civil_twilight_end":"2020-06-25T20:11:08+00:00",'
          '"nautical_twilight_begin":"2020-06-25T03:51:47+00:00",'
          '"nautical_twilight_end":"2020-06-25T20:49:19+00:00",'
          '"astronomical_twilight_begin":"2020-06-25T03:09:00+00:00",'
          '"astronomical_twilight_end":"2020-06-25T21:32:07+00:00"},'
          '"status":"OK"}';

      when(client.get('https://api.sunrise-sunset.org/json?'
          'lat=36.7201600&lng=-4.4203400&formatted=0'))
        .thenAnswer((_) async => http.Response(mockData, 200));

      expect(await fetchSunData(client), isA<SunData>());
    });

    test('throws exception on invalid API request', () {
      final client = MockClient();
      final String mockData = '{"results":"","status":"INVALID_REQUEST"}';

      when(client.get('https://api.sunrise-sunset.org/json?'
          'lat=36.7201600&lng=-4.4203400&formatted=0'))
          .thenAnswer((_) async => http.Response(mockData, 400));

      expect(fetchSunData(client), throwsException);
    });

    test('throws exception on invalid response', () {
      final client = MockClient();

      when(client.get('https://api.sunrise-sunset.org/json?'
          'lat=36.7201600&lng=-4.4203400&formatted=0'))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchSunData(client), throwsException);
    });

  });

}