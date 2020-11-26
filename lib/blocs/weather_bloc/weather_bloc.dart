import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/blocs/weather_bloc/weather_event.dart';
import 'package:lab_1/blocs/weather_bloc/weather_state.dart';
import 'package:lab_1/data/api.dart';
import 'package:lab_1/models/location.dart';
import 'package:lab_1/models/location_weather.dart';
import 'package:lab_1/models/server_error.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherLoadingState());

  Api _api = Api();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is GetLocationWeatherEvent) {
      yield* _mapGetLocationsToState(event.location);
    }
  }

  Stream<WeatherState> _mapGetLocationsToState(Location location) async* {
    try {
      Response response = await _api.getLocationWeather(double.parse(location.lat), double.parse(location.lng));
      if (response.statusCode == 200) {
        LocationWeather locationWeather = LocationWeather.fromJson(response.data);
        locationWeather.location = location;
        yield WeatherLoadedState(locationWeather);
      }
    } on DioError catch (error) {
      print(error);
      var data = error.response?.data;
      if (data is Map<String, dynamic>) {
        ServerError serverError = ServerError.fromJson(data);
        yield ErrorWeatherState(serverError);
      }
      yield DioErrorWeatherState(error);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      yield ErrorWeatherState(ServerError(-1, 'Unexpected Error'));
    }
  }
}