abstract class LocationsEvent {}

class GetLocationsEvent extends LocationsEvent {
  String searchQuery;

  GetLocationsEvent(this.searchQuery);
}