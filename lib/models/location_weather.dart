import 'package:lab_1/models/day_weather.dart';
import 'package:lab_1/models/location.dart';

class LocationWeather {
  Location location;
  List<DayWeather> weather;

  LocationWeather(this.location, this.weather);

  LocationWeather.fromJson(Map<String, dynamic> m)
      : weather = m['properties']['timeseries']
                ?.map<DayWeather>((map) => DayWeather.fromJson(map))
                ?.toList() ?? [],
        location = null;
}