import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_1/models/location.dart';
import 'package:lab_1/models/location_weather.dart';
import 'package:lab_1/models/server_error.dart';

abstract class WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends Equatable implements WeatherState {
  final LocationWeather locationsWeather;

  WeatherLoadedState(this.locationsWeather);

  @override
  List<Object> get props => [locationsWeather];
}

class ErrorWeatherState extends WeatherState {
  final ServerError error;

  ErrorWeatherState(this.error);
}

class DioErrorWeatherState extends WeatherState {
  final DioError error;

  DioErrorWeatherState(this.error);
}
