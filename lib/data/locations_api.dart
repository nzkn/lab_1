// import 'package:dio/dio.dart';
//
// class Api {
//   static const String _baseUrl = 'https://api.locationiq.com/v1/autocomplete.php?key=pk.ba657213353d9b737c79ed08ac6dfe22&q';
//
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: _baseUrl,
//     ),
//   )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
//
//   Future<Response> getLocationWeather(double lat, double lng) {
//     return _dio.get(
//       'weatherapi/locationforecast/2.0/compact',
//       queryParameters: {
//         'lat': lat,
//         'lon': lng,
//       },
//     );
//   }