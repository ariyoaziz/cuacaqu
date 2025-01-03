// screen/location_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cuacaqu/bloc/weather_bloc.dart';
import 'package:cuacaqu/bloc/weather_bloc_event.dart';
import 'package:cuacaqu/controllers/home_controller.dart';
import 'package:cuacaqu/screen/home.dart';

class LocationService extends StatelessWidget {
  const LocationService({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: determinePosition(), // Mendapatkan posisi pengguna
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body:
                Center(child: CircularProgressIndicator()), // Tampilkan loading
          );
        } else if (snap.hasError) {
          // Menangani error
          String errorMessage = snap.error.toString();
          if (errorMessage.contains('denied')) {
            errorMessage = 'Location permission is denied. Please enable it.';
          } else if (errorMessage.contains('disabled')) {
            errorMessage =
                'Location services are disabled. Please enable them.';
          } else if (errorMessage.contains('permanently denied')) {
            errorMessage =
                'Location permission is permanently denied. We cannot request it.';
          }
          return Scaffold(
            body: Center(
              child:
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
            ),
          );
        } else if (snap.hasData) {
          // Kirim data lokasi ke BLoC
          return BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(
                homeController: context.read<HomeController>())
              ..add(FetchWeather(snap.data!)), // Kirim posisi pengguna ke BLoC
            child: const HomePage(), // Tampilkan halaman Home
          );
        } else {
          return const Scaffold(
            body: Center(
              child:
                  Text('Unable to fetch location. Please check your settings.'),
            ),
          );
        }
      },
    );
  }

  // Fungsi untuk mendapatkan posisi pengguna
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          'Location services are disabled. Please enable them.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied. Please enable it.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission is permanently denied. We cannot request permission.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
