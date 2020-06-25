import 'dart:convert';

import 'package:http/http.dart' as http;

class SunData {
  final DateTime sunrise;
  final DateTime sunset;
  final int dayLength;

  SunData({
    this.sunrise,
    this.sunset,
    this.dayLength,
  });

  factory SunData.fromJson(Map<String, dynamic> json) {
    return SunData(
      sunrise: DateTime.parse(json["sunrise"]),
      sunset: DateTime.parse(json["sunset"]),
      dayLength: json["day_length"],
    );
  }

  get daylight => sunset.difference(sunrise).inSeconds;
}

Future<SunData> fetchSunData(http.Client client) async {
  final response =
      await client.get('https://api.sunrise-sunset.org/json?'
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