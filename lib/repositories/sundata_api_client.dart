import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:testy/models/models.dart';
import 'dart:convert';

class SunDataApiClient {
  static const baseUrl = 'https://api.sunrise-sunset.org';
  final http.Client httpClient;

  SunDataApiClient({
    @required this.httpClient,
  }) : assert (httpClient != null);

  Future<SunData> byCoordinates(double latitude, double longitude) async {

    final String url = 'https://api.sunrise-sunset.org/json?'
        'lat=$latitude&lng=$longitude&formatted=0';
    final response =
    await httpClient.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic>jsonData = json.decode(response.body);
      if (jsonData['status'] != "OK") {
        throw Exception("API response error ${jsonData['status']}");
      }
      return SunData.fromJson(jsonData["results"]);
    } else {
      throw Exception("Failed to fetch data from API");
    }
  }

}
