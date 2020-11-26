import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_1/models/location.dart';
import 'package:lab_1/models/location_weather.dart';
import 'package:lab_1/models/server_error.dart';

abstract class LocationsState {}

class LocationsLoadingState extends LocationsState {}

class LocationsLoadedState extends Equatable implements LocationsState {
  final List<Location> locations;

  LocationsLoadedState(this.locations);

  @override
  List<Object> get props => [locations];
}

class ErrorLocationsState extends LocationsState {
  final ServerError error;

  ErrorLocationsState(this.error);
}

class DioErrorLocationsState extends LocationsState {
  final DioError error;

  DioErrorLocationsState(this.error);
}
