import 'package:dio/dio.dart';

class Api {
  static const String _baseUrl = 'https://api.met.no/';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  static const String _baseUrl2 = 'https://api.locationiq.com/';
  static const String key = 'pk.ba657213353d9b737c79ed08ac6dfe22';

  final Dio _dio2 = Dio(
    BaseOptions(
      baseUrl: _baseUrl2,
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  Future<Response> getLocationWeather(double lat, double lng) {
    return _dio.get(
      'weatherapi/locationforecast/2.0/compact',
      queryParameters: {
        'lat': lat,
        'lon': lng,
      },
    );
  }

  Future<Response> getLocations(String city) {
    return _dio2.get(
      'v1/autocomplete.php',
      queryParameters: {
        'key': key,
        'q': city,
      },
    );
  }
}
