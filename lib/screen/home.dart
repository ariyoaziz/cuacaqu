import 'package:cuacaqu/themes/colors.dart';
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
  String currentDateTime = "";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

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
        location = "Layanan lokasi tidak aktif! Yuk, aktifkan!";
        isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = "Izin lokasi ditolak! Buka pengaturan, ya.";
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location = "Izin lokasi ditolak permanen! Periksa pengaturan.";
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
      _getCurrentDateTime();
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

  // Daftar widget untuk setiap halaman yang akan ditampilkan
  final List<Widget> _pages = [
    // Halaman Home
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    // Halaman Save
    Center(child: Text('Save Page', style: TextStyle(fontSize: 24))),
    // Halaman Search
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    // Halaman Account
    Center(child: Text('Account Page', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "CuacaQu",
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.sunny, size: 32, color: Colors.yellow),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, size: 32, color: Colors.white),
              onPressed: () {
                print("Notifikasi ditekan");
              },
            ),
          ],
          backgroundColor: Colors.blue[800],
          toolbarHeight: 100,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lokasi dan Sapaan
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Salam Pengguna
                          Row(
                            children: [
                              Text(
                                'Hai, Ariyo Aziz!',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[900],
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          // Pesan Pagi
                          Row(
                            children: [
                              Text(
                                'Selamat Pagi, semoga harimu cerah!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey[600],
                                  fontStyle: FontStyle.italic,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Lokasi
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              // Menggunakan Expanded untuk membuat teks lokasi menyesuaikan lebar
                              Expanded(
                                child: Text(
                                  location,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueAccent,
                                    letterSpacing: 1.2,
                                    overflow: TextOverflow
                                        .ellipsis, // Menambahkan elipsis jika terlalu panjang
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3,
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Tanggal dan Waktu
                          Row(
                            children: [
                              // Ikon Jam dengan Efek Animasi
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              // Tanggal dan Waktu
                              Expanded(
                                child: Text(
                                  currentDateTime,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blueGrey[600],
                                    letterSpacing: 1.1,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3,
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Cuaca Sekarang
                    if (currentWeather != null) ...[
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card untuk Ikon Cuaca Besar dan Derajat Suhu
                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.85, // Lebar lebih besar
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade100,
                                        Colors.blue.shade500,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Ikon Cuaca Besar dengan Efek Animasi
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        padding: const EdgeInsets.all(25),
                                        decoration: BoxDecoration(
                                          color: Colors.orangeAccent.shade200,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orangeAccent
                                                  .withOpacity(0.4),
                                              blurRadius: 15,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          currentWeather!.weatherMain == 'Clear'
                                              ? Icons.wb_sunny
                                              : currentWeather!.weatherMain ==
                                                      'Rain'
                                                  ? Icons.beach_access
                                                  : Icons.cloud,
                                          size: 110,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      // Derajat Suhu dengan Animasi dan Efek Highlight
                                      Text(
                                        '${currentWeather!.temperature.toStringAsFixed(0)}°C',
                                        style: TextStyle(
                                          fontSize: 75, // Ukuran lebih besar
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .white, // Menggunakan warna putih agar lebih kontras
                                          shadows: [
                                            Shadow(
                                              blurRadius: 20,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              offset: Offset(5, 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Garis Pembatas (Efek Halus)
                                      Container(
                                        width: 100,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade300,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Teks yang Menyertai dengan Efek Bayangan
                                      Text(
                                        'Cuaca Hari Ini',
                                        style: TextStyle(
                                          fontSize:
                                              24, // Ukuran font lebih besar
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .white, // Menggunakan warna putih agar lebih kontras
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 50),
// Judul "Detail Cuaca"
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Detail Cuaca',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey[800],
                                    shadows: [
                                      Shadow(
                                        blurRadius: 5,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
// List Detail Cuaca
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Kolom Kiri
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // Menyelaraskan ke tengah secara horizontal
                                        children: [
                                          _buildWeatherDetailCard(
                                              'Cuaca',
                                              '${currentWeather!.weatherMain}, ${currentWeather!.description}',
                                              Icons.wb_sunny),
                                          _buildWeatherDetailCard(
                                              'Suhu Maks',
                                              '${currentWeather!.tempMax.toStringAsFixed(0)}°C',
                                              Icons.thermostat),
                                          _buildWeatherDetailCard(
                                              'Suhu Min',
                                              '${currentWeather!.tempMin.toStringAsFixed(0)}°C',
                                              Icons.thermostat_outlined),
                                          _buildWeatherDetailCard(
                                              'Terasa Seperti',
                                              '${currentWeather!.feelsLike.toStringAsFixed(0)}°C',
                                              Icons.whatshot),
                                        ],
                                      ),
                                    ),
                                    // Kolom Kanan
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // Menyelaraskan ke tengah secara horizontal
                                        children: [
                                          _buildWeatherDetailCard(
                                              'Kelembapan',
                                              '${currentWeather!.humidity}%',
                                              Icons.water_drop),
                                          _buildWeatherDetailCard(
                                              'Tekanan Udara',
                                              '${currentWeather!.pressure} hPa',
                                              Icons.compress),
                                          _buildWeatherDetailCard(
                                              'Sunrise',
                                              '${currentWeather!.sunriseTime}',
                                              Icons.wb_sunny),
                                          _buildWeatherDetailCard(
                                              'Sunset',
                                              '${currentWeather!.sunsetTime}',
                                              Icons.nightlight_round),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ],

                    const SizedBox(height: 20),
                    // Ramalan Cuaca 5 Hari
                    if (forecastWeather != null &&
                        forecastWeather!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Ramalan Cuaca 5 Hari Ke Depan!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                            shadows: [
                              Shadow(
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: forecastWeather!.length,
                        itemBuilder: (context, index) {
                          var forecast = forecastWeather![index];
                          final DateFormat dateFormatter =
                              DateFormat('dd MMMM yyyy');
                          String formattedDate = dateFormatter.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  forecast.dt * 1000));

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            elevation: 6,
                            color: Colors.blue.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Ikon cuaca
                                  Icon(
                                    forecast.weatherMain == 'Clear'
                                        ? Icons.wb_sunny
                                        : forecast.weatherMain == 'Rain'
                                            ? Icons.beach_access
                                            : Icons.cloud,
                                    size: 40,
                                    color: Colors.orangeAccent,
                                  ),
                                  const SizedBox(width: 16),
                                  // Detail cuaca
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Menampilkan Tanggal di atas
                                        Text(
                                          'Tanggal: $formattedDate',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                8), // Spasi antar tanggal dan cuaca
                                        Text(
                                          'Cuaca: ${forecast.weatherMain}, ${forecast.description}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey[800],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Suhu: ${forecast.temperature.toStringAsFixed(0)}°C',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Suhu Maks: ${forecast.tempMax.toStringAsFixed(0)}°C',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Suhu Min: ${forecast.tempMin.toStringAsFixed(0)}°C',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ],
                                    ),
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

// Fungsi untuk menampilkan detail cuaca dengan card dan ikon
Widget _buildWeatherDetailCard(String title, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 150, // Tentukan tinggi tetap untuk setiap card agar seragam
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.blueAccent,
                size: 30, // Ukuran ikon yang seragam
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Vertikal center
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16, // Ukuran font seragam untuk judul
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16, // Ukuran font seragam untuk nilai
                        color: Colors.blueGrey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Fungsi untuk membuat detail cuaca dengan judul dan nilai
Widget _buildWeatherDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
