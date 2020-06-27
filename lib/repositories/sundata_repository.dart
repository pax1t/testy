import 'package:meta/meta.dart';
import 'package:testy/repositories/repositories.dart';
import 'package:testy/sundata.dart';

class SunDataRepository {
  final SunDataApiClient apiClient;

  SunDataRepository({
    @required this.apiClient,
  }) : assert(apiClient != null);

  Future<SunData> getSunset() async {
    return apiClient.fetchSunData();
  }
}
