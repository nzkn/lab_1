import 'package:lab_1/models/location.dart';

abstract class WeatherEvent {}

class GetLocationWeatherEvent extends WeatherEvent {
  final Location location;

  GetLocationWeatherEvent(this.location);
}