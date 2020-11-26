class Location {
  String name;
  String lat;
  String lng;
  String city;
  String country;

  Location(this.name, this.lat, this.lng, {this.city, this.country});

  Location.fromJson(Map<String, dynamic> m)
      : name = m['address']['name'],
        lat = m['lat'],
        lng = m['lon'],
        city = m['address']['state'],
        country = m['address']['country'];
}
