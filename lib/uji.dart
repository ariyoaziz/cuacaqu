import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart'; // Pastikan package ini diimport
import '../controllers/home_controller.dart';
import '../models/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Mendapatkan lokasi...";
  bool isLoading = true;
  Weather? currentWeather;
  List<Weather>? forecastWeather;
  String currentDateTime = ""; // Menyimpan tanggal dan waktu saat ini

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // Fungsi untuk mendapatkan tanggal dan waktu saat ini
  void _getCurrentDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMMM yyyy, HH:mm');
    setState(() {
      currentDateTime = formatter.format(now);
    });
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        location = "Layanan lokasi tidak diaktifkan!";
        isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = "Izin lokasi ditolak!";
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location = "Izin lokasi ditolak secara permanen!";
        isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        location =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
        isLoading = false;
      });
      _getWeather(position.latitude, position.longitude);
      _getCurrentDateTime(); // Pastikan ini dipanggil setelah lokasi didapatkan
    } catch (e) {
      setState(() {
        location = "Gagal mendapatkan lokasi: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _getWeather(double latitude, double longitude) async {
    try {
      HomeController homeController = HomeController();
      currentWeather =
          await homeController.getCurrentWeather(latitude, longitude);
      forecastWeather =
          await homeController.getDailyForecast(latitude, longitude);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        currentWeather = null;
        forecastWeather = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Cuaca Hari Ini", style: TextStyle(fontSize: 22)),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Lokasi Anda: $location',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tanggal & Waktu: $currentDateTime', // Menampilkan tanggal dan waktu sekarang
                        style: const TextStyle(
                            fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                    if (currentWeather != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 5,
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cuaca: ${currentWeather!.weatherMain}, ${currentWeather!.description}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Suhu: ${currentWeather!.temperature.toStringAsFixed(0)}°C',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Suhu Maks: ${currentWeather!.tempMax.toStringAsFixed(0)}°C',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Suhu Min: ${currentWeather!.tempMin.toStringAsFixed(0)}°C',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sunrise: ${currentWeather!.sunriseTime}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Sunset: ${currentWeather!.sunsetTime}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Terasa Seperti: ${currentWeather!.feelsLike.toStringAsFixed(0)}°C',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Kelembapan: ${currentWeather!.humidity}%',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Tekanan Udara: ${currentWeather!.pressure} hPa',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (forecastWeather != null &&
                        forecastWeather!.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Ramalan Cuaca 5 Hari',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: forecastWeather!.length,
                        itemBuilder: (context, index) {
                          var forecast = forecastWeather![index];

                          // Format tanggal menggunakan DateFormat
                          final DateFormat dateFormatter =
                              DateFormat('dd MMMM yyyy');
                          String formattedDate = dateFormatter.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  forecast.dt * 1000));

                          return Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 5,
                            color: Colors.blue.shade100,
                            child: ListTile(
                              title: Text(
                                'Cuaca: ${forecast.weatherMain}, ${forecast.description}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal: $formattedDate', // Menampilkan tanggal yang sudah diformat
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Suhu: ${forecast.temperature.toStringAsFixed(0)}°C',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Suhu Maks: ${forecast.tempMax.toStringAsFixed(0)}°C',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Suhu Min: ${forecast.tempMin.toStringAsFixed(0)}°C',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
