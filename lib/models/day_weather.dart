class DayWeather {
  final DateTime time;
  final double temperature;

  DayWeather.fromJson(Map<String, dynamic> m)
      : time = m['time'] == null ? null : DateTime.parse(m['time']),
        temperature = m['data']['instant']['details']['air_temperature'];
}
