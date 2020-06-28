
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

