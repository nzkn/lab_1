import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/blocs/blocs.dart';
import 'package:lab_1/data/api.dart';
import 'package:lab_1/models/location.dart';
import 'package:lab_1/models/server_error.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc() : super(LocationsLoadingState());

  Api _api = Api();

  @override
  Stream<LocationsState> mapEventToState(LocationsEvent event) async* {
   if (event is GetLocationsEvent) {
     yield* _mapGetLocationsToState(event.searchQuery);
   }
  }

  Stream<LocationsState> _mapGetLocationsToState(String searchQuery) async* {
    try {
      yield LocationsLoadingState();
      Response response = await _api.getLocations(searchQuery);
      if (response.statusCode == 200) {
        print(response.data);
        List<Location> locations = response.data
            .map<Location>((json) => Location.fromJson(json)).toList();
        yield LocationsLoadedState(locations);
      }
    } on DioError catch (error) {
      print(error);
      var data = error.response?.data;
      if (data is Map<String, dynamic>) {
        ServerError serverError = ServerError.fromJson(data);
        yield ErrorLocationsState(serverError);
      }
      yield DioErrorLocationsState(error);
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      yield ErrorLocationsState(ServerError(-1, 'Unexpected Error'));
    }
  }
}