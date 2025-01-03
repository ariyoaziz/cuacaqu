// bloc/weather_state.dart

import 'package:equatable/equatable.dart';
import '../models/weather.dart';

// --- State ---

sealed class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object> get props => [];
}

class WeatherBlocInitial extends WeatherBlocState {}

class WeatherBlocLoading extends WeatherBlocState {}

class WeatherBlocFailure extends WeatherBlocState {
  final String error;

  const WeatherBlocFailure({this.error = 'An error occurred'});

  @override
  List<Object> get props => [error];
}

class WeatherBlocSuccess extends WeatherBlocState {
  final Weather weather;
  final List<Weather> forecast;

  const WeatherBlocSuccess(this.weather, this.forecast);

  @override
  List<Object> get props => [weather, forecast];
}
