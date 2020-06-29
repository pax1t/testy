import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:testy/repositories/repositories.dart';

class MockLocation extends Mock implements Location {}
class MockLocationApiClient extends Mock implements LocationApiClient {}

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

  test('Throw assertion on creating client without location instance', () {
    try {
      new LocationApiClient();
    } catch(e) {
      expect(e, isA<AssertionError>());
    }
  });

  test('Throw assertion on creating repository without client instance', () {
    try {
      new LocationRepository();
    } catch(e) {
      expect(e, isA<AssertionError>());
    }
  });

  test('Check permission and service on access to device location', () async {
    final client = MockLocationApiClient();
    final location = MockLocation();
    when(location.getLocation()).thenAnswer((_) async => LocationData.fromMap({
      'latitude': 50.00,
      'longitude': 51.01,
      'altitude': 52.02,
    }));
    when(client.serviceEnabled()).thenAnswer((_) async => true);
    when(client.permissionGranted()).thenAnswer((_) async => true);
    final locationData = await location.getLocation();
    expect(locationData, isA<LocationData>());
  });

  test('Throw exception when permission denied or service disabled', () async {
    final location = MockLocation();
    final client = LocationApiClient(location: location);
    when(location.hasPermission()).thenAnswer((_) async => PermissionStatus.denied);
    when(location.serviceEnabled()).thenAnswer((_) async => false);
    when(location.requestService()).thenAnswer((_) async => false);
    expect(client.getLocationWithCheck(), throwsException);

    when(location.hasPermission()).thenAnswer((_) async => PermissionStatus.denied);
    when(location.requestPermission()).thenAnswer((_) async => PermissionStatus.denied);
    when(location.serviceEnabled()).thenAnswer((_) async => true);
    expect(client.getLocationWithCheck(), throwsException);

  });

  test('Try to request permissions on permission denied', () async {
    final location = MockLocation();
    final client = LocationApiClient(location: location);
    when(location.hasPermission()).thenAnswer((_) async => PermissionStatus.denied);
    when(location.serviceEnabled()).thenAnswer((_) async => false);
    when(location.requestService()).thenAnswer((_) async => false);
    when(location.requestPermission()).thenAnswer((_) async => PermissionStatus.denied);
    expect(client.getLocationWithCheck(), throwsException);
  });

}