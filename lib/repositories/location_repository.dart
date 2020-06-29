import 'package:location/location.dart';
import 'package:testy/repositories/repositories.dart';

class LocationRepository {
  final LocationApiClient _locationApiClient;
  LocationRepository({
    LocationApiClient locationApiClient
}) : assert(locationApiClient != null),
  _locationApiClient = locationApiClient;

  Future<LocationData> getLocation() async {
    return await _locationApiClient.getLocationWithCheck();
  }
}