
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:testy/models/models.dart';
import 'package:testy/repositories/repositories.dart';
import 'package:http/http.dart' as http;

class MockLocationData extends Mock implements LocationData {}
class MockClient extends Mock implements http.Client {}
class MockSunApiClient extends Mock implements SunDataApiClient {}

void main() {
  /// TODO: add API error response tests

  test('Returning SunData by given location', () async {
    final mockClient = MockClient();
    final sunRepo = SunDataRepository(
      apiClient: SunDataApiClient(httpClient: mockClient),
    );
    when(mockClient.get(contains('api'))).thenAnswer((_) async => http.Response('', 404));
    expect(sunRepo.byLocation(50.0, 50.0), throwsException);
  });

  test('SunData by given location', () async {
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

    final mockClient = MockClient();
    final sunRepo = SunDataRepository(
      apiClient: SunDataApiClient(httpClient: mockClient),
    );

    final RegExp _queryRegExp = RegExp(r'(50.0).*(60.0)');

    when(mockClient.get(matches(_queryRegExp)))
        .thenAnswer((_) async => http.Response(apiSunData, 200));
    expect(await sunRepo.byLocation(50.0, 60.0), isA<SunData>());
  });


}