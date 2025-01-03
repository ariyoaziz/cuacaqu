class Weather {
  final String areaName;
  final String weatherMain;
  final String description;
  final double temperature;
  final double tempMax;
  final double tempMin;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final int dt;
  final String sunriseTime;
  final String sunsetTime;

  Weather({
    required this.areaName,
    required this.weatherMain,
    required this.description,
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.dt,
    required this.sunriseTime,
    required this.sunsetTime,
  });

  // Constructor untuk data cuaca hari ini
  factory Weather.fromJson(Map<String, dynamic> json) {
    DateTime sunriseFormat =
        DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000);
    DateTime sunsetFormat =
        DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000);

    return Weather(
      areaName: json['name'] ?? 'Unknown Location',
      weatherMain: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      dt: json['dt'],
      sunriseTime:
          "${sunriseFormat.hour}:${sunriseFormat.minute.toString().padLeft(2, '0')}",
      sunsetTime:
          "${sunsetFormat.hour}:${sunsetFormat.minute.toString().padLeft(2, '0')}",
    );
  }

  // Constructor untuk ramalan cuaca 5 hari
  factory Weather.fromForecastJson(Map<String, dynamic> json) {
    return Weather(
      areaName: '', // Tidak relevan untuk data ramalan
      weatherMain: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      feelsLike: json['main']['feels_like']?.toDouble() ?? 0.0, // Bisa null
      humidity: json['main']['humidity'] ?? 0, // Bisa null
      pressure: json['main']['pressure'] ?? 0,
      dt: json['dt'], // Bisa null
      sunriseTime: "", // Tidak tersedia untuk data ramalan
      sunsetTime: "", // Tidak tersedia untuk data ramalan
    );
  }
}
