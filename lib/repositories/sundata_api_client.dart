import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:testy/sundata.dart';

class SunDataApiClient {
  static const baseUrl = 'https://api.sunrise-sunset.org';
  final http.Client httpClient;

  SunDataApiClient({
    @required this.httpClient,
  }) : assert (httpClient != null);


  Future<SunData> fetchSunData() async {
    /// TODO: pass device location data to this function
    final response =
    await httpClient.get('https://api.sunrise-sunset.org/json?'
        'lat=36.7201600&lng=-4.4203400&formatted=0');

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
