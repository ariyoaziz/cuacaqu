import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/home_controller.dart';
import '../models/weather.dart';
import '../bloc/weather_bloc_event.dart';
import '../bloc/weather_bloc_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  final HomeController homeController;

  WeatherBloc({required this.homeController}) : super(WeatherBlocInitial());

  @override
  Stream<WeatherBlocState> mapEventToState(WeatherBlocEvent event) async* {
    if (event is FetchWeather) {
      yield* _mapFetchWeatherToState(event.position);
    }
  }

  Stream<WeatherBlocState> _mapFetchWeatherToState(Position position) async* {
    yield WeatherBlocLoading();
    try {
      // Fetch cuaca saat ini
      Weather weather = await homeController.getCurrentWeather(
          position.latitude, position.longitude);

      // Fetch ramalan cuaca 5 hari
      List<Weather> forecast = await homeController.getDailyForecast(
          position.latitude, position.longitude);

      // Mengembalikan state sukses dengan cuaca saat ini dan ramalan cuaca 5 hari
      yield WeatherBlocSuccess(weather, forecast);
    } catch (e) {
      // Mengembalikan state gagal jika terjadi error
      yield WeatherBlocFailure(error: e.toString());
    }
  }
}
