import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:testy/repositories/repositories.dart';

class MockLocation extends Mock implements Location {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Location Repository test', () async {
    final mockLocation = MockLocation();
    final locationRepository = LocationRepository(
      locationApiClient: LocationApiClient(location: mockLocation),
    );
    final locationData = LocationData.fromMap({
      'latitude': 50.00,
      'longitude': 51.01,
      'altitude': 52.02,
    });
    when(mockLocation.getLocation()).thenAnswer((_) async => locationData);
    when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);
    when(mockLocation.hasPermission()).thenAnswer((_) async => PermissionStatus.granted);
    final location = await locationRepository.getLocation();
    expect(location, isA<LocationData>());
    expect(location.latitude, 50.00);
    expect(location.longitude, 51.01);
    expect(location.altitude, 52.02);
  });

}