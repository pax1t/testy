import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:testy/models/models.dart';
import 'package:testy/repositories/repositories.dart';

class MockClient extends Mock implements http.Client {}

void main () {

  // Mocking only httpClient
  group('Fetch SunData from Repository', () {

    final String apiRequest = 'https://api.sunrise-sunset.org/json?'
        'lat=36.7201600&lng=-4.4203400&formatted=0';
    // Keep it readable but without line breaks
    final String apiSunData = '{"results":{'
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

    test('fetch SunData from Repository and ApiClient', () async {

      final client = MockClient();
      when(client.get(apiRequest))
          .thenAnswer((_) async => http.Response(apiSunData, 200));
      expect(await SunDataRepository(
          apiClient: SunDataApiClient(httpClient: client))
          .getSunset(),
          isA<SunData>(),
      );
    });

    test('Throws exception on unknown service error', () {
      final client = MockClient();
      final String mockData = '{"results":"","status":"UNKNOWN_ERROR"}';

      when(client.get(apiRequest))
          .thenAnswer((_) async => http.Response(mockData, 200));
      expect(SunDataRepository(
          apiClient: SunDataApiClient(httpClient: client))
          .getSunset(),
        throwsException,
      );
    });

    test('Throw Exception on API not found', () {
      final client = MockClient();

      when(client.get(apiRequest))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      expect(SunDataRepository(
          apiClient: SunDataApiClient(httpClient: client))
          .getSunset(),
        throwsException,
      );
    });

    test('Throw Exception on invalid API request', () {
      final client = MockClient();
      final String mockData = '{"results":"","status":"INVALID_REQUEST"}';

      when(client.get(apiRequest))
          .thenAnswer((_) async => http.Response(mockData, 400));
      expect(SunDataRepository(
          apiClient: SunDataApiClient(httpClient: client))
          .getSunset(),
        throwsException,
      );
    });

    test('SunData instance has data', () async {
      final client = MockClient();

      when(client.get(apiRequest))
          .thenAnswer((_) async => http.Response(apiSunData, 200));
      final sunData = await SunDataRepository(apiClient: SunDataApiClient(httpClient: client))
        .getSunset();
      // Sunset always after sunrise
      expect(sunData.sunset.isAfter(sunData.sunrise), true);
    });

  });

}