import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class HomeController {
  final String apiKey =
      '0f1818956b7e49a7827a768c55d16f23'; // Ganti dengan API key Anda

  // Ambil cuaca saat ini
  Future<Weather> getCurrentWeather(double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        throw Exception('Failed to load current weather: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching current weather: $e');
    }
  }

  // Ambil ramalan cuaca harian
  Future<List<Weather>> getDailyForecast(
      double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> forecastData = data['list'];

        // Mengelompokkan ramalan berdasarkan tanggal
        Map<String, List<dynamic>> groupedByDay = {};
        for (var forecast in forecastData) {
          String date =
              DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000)
                  .toUtc()
                  .toString()
                  .split(' ')[0]; // Ambil hanya tanggal
          groupedByDay.putIfAbsent(date, () => []).add(forecast);
        }

        // Ambil tanggal hari ini
        String today = DateTime.now().toUtc().toString().split(' ')[0];

        // Menyaring ramalan untuk tanggal yang lebih besar dari hari ini
        List<Weather> filteredForecast = groupedByDay.entries.map((entry) {
          double totalTemp = 0.0;
          double maxTemp = double.negativeInfinity;
          double minTemp = double.infinity;

          for (var forecast in entry.value) {
            double temp = forecast['main']['temp'].toDouble();
            totalTemp += temp;
            maxTemp = maxTemp < forecast['main']['temp_max']
                ? forecast['main']['temp_max']
                : maxTemp;
            minTemp = minTemp > forecast['main']['temp_min']
                ? forecast['main']['temp_min']
                : minTemp;
          }

          double avgTemp = totalTemp / entry.value.length;

          return Weather(
            areaName: '', // Tidak relevan untuk data ramalan
            weatherMain: entry.value[0]['weather'][0]['main'],
            description: entry.value[0]['weather'][0]['description'],
            temperature: avgTemp,
            tempMax: maxTemp,
            tempMin: minTemp,
            feelsLike: 0.0, // Tidak tersedia dalam ramalan harian
            humidity: 0, // Tidak tersedia dalam ramalan harian
            pressure: 0, // Tidak tersedia dalam ramalan harian
            sunriseTime: '', // Tidak tersedia dalam ramalan harian
            sunsetTime: '',
            dt: entry.value[0]['dt'], // Ambil timestamp (dt) dari data API
          );
        }).where((forecast) {
          String forecastDate =
              DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000)
                  .toUtc()
                  .toString()
                  .split(' ')[0]; // Ambil hanya tanggal
          return forecastDate.compareTo(today) >
              0; // Hanya ambil ramalan setelah hari ini
        }).toList();

        return filteredForecast;
      } else {
        throw Exception('Failed to load daily forecast: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching daily forecast: $e');
    }
  }
}
