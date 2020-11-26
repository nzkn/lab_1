import 'package:dio/dio.dart';
import 'package:lab_1/data/api.dart';
import 'package:lab_1/models/location_weather.dart';

class Repo {

  Api _api = Api();

  Future<LocationWeather> getLocationWeather(double lat, double lng) async {
    Response response = await _api.getLocationWeather(lat, lng);
    if (response.statusCode == 200) {
      LocationWeather locationWeather = LocationWeather.fromJson(response.data);
      return locationWeather;
    }
  }
}