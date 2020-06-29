import 'package:location/location.dart';

class LocationApiClient {

  final Location location;
  LocationApiClient({
    this.location,
  }): assert(location != null);

  Future<bool> serviceEnabled() async {
    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled) {
      return true;
    } else {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) {
        return true;
      }
    }
    return false;
  }

  Future<bool> permissionGranted () async {
    PermissionStatus _permissionGranted;

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.granted) {
      return true;
    } else {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return true;
      }
    }
    return false;

  }

  Future<LocationData> getLocationWithCheck () async {
    final service = await serviceEnabled();
    final permission = await permissionGranted();

    if (service && permission) {
      final LocationData locationData = await location.getLocation();
      return locationData;
    } else {
      throw Exception('Error getting location!');
    }
  }

  Future<LocationData> getLocation () async {
    await location.requestPermission();
    await permissionGranted();
    LocationData locationData = await location.getLocation();
    // print('${locationData.latitude} - ${locationData.longitude}');
    if (locationData != null) {
      return locationData;
    } else {
      throw Exception('Error getting location!');
    }
  }

}