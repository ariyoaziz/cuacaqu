// bloc/weather_event.dart

import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart'; // Untuk posisi pengguna

// --- Event ---

sealed class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherBlocEvent {
  final Position position;

  const FetchWeather(this.position);

  @override
  List<Object> get props => [position];
}
