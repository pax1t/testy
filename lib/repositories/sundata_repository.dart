import 'package:meta/meta.dart';
import 'package:testy/models/models.dart';
import 'package:testy/repositories/repositories.dart';

class SunDataRepository {
  final SunDataApiClient apiClient;

  SunDataRepository({
    @required this.apiClient,
  }) : assert(apiClient != null);

  Future<SunData> byLocation(double latitude, double longitude) async {
    return apiClient.byCoordinates(latitude, longitude);
  }
}
