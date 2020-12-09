import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab_1/models/location.dart';
import 'package:lab_1/models/location_weather.dart';
import 'package:lab_1/repo/repo.dart';
import 'package:lab_1/ui/resources/resources.dart';

import 'locations_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String route = "/";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool loading;
  List<LocationWeather> locations;
  Repo repo = Repo();
  Animation<double> _smoothAnimation;
  Animation<double> _fastAnimation;
  AnimationController _controller;

  @override
  void initState() {
    loading = false;
    locations = [];
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    })..repeat();

    _smoothAnimation = Tween<double>(begin: 0.0, end: 3)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _fastAnimation = Tween<double>(begin: 2.0, end: 10)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Weather forecast",
            style: Styles.headerTextStyle.copyWith(color: AppColors.white),
          ),
        ),
        body: loading == false
            ? ListView.builder(
                padding: EdgeInsets.all(7),
                shrinkWrap: true,
                primary: false,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return _buildLocationWeatherWidget(locations[index], index);
                },
              )
            : _buildLoadingWidget(),
        floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
              bottom: 70,
              right: 0,
              child: FloatingActionButton(
                heroTag: 1,
                child: Icon(Icons.add_location_alt_rounded),
                onPressed: () => _onDetectLocationPressed(),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: FloatingActionButton(
                heroTag: 2,
                child: Icon(Icons.add),
                onPressed: () => _onSelectLocationPressed(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationWeatherWidget(LocationWeather locationWeather, int index) {
    var todayWeather = locationWeather.weather.firstWhere((locationWeather) => locationWeather.time.day == DateTime.now().day);
    var tomorrowWeather = locationWeather.weather.firstWhere((locationWeather) => locationWeather.time.day == DateTime.now().add(Duration(days: 1)).day);
    var afterTomorrowWeather = locationWeather.weather.firstWhere((locationWeather) => locationWeather.time.day == DateTime.now().add(Duration(days: 2)).day);
    return Padding(
      padding: EdgeInsets.only(bottom: 7),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      locationWeather.location.name,
                      style: Styles.basicTextStyle
                          .copyWith(
                          fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      setState(() {
                        locations.removeAt(index);
                      });
                    },
                    child: Icon(Icons.close, size: 18),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildDayWeatherWidget(
                    todayWeather.temperature.toString(),
                    "Today",
                  ),
                  SizedBox(width: 15),
                  _buildDayWeatherWidget(
                    tomorrowWeather.temperature.toString(),
                    "Tomorrow",
                  ),
                  SizedBox(width: 15),
                  _buildDayWeatherWidget(
                    afterTomorrowWeather.temperature.toString(),
                    "After Tomorrow",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayWeatherWidget(String temp, String day) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            temp ?? "",
            style: Styles.basicTextStyle.copyWith(fontWeight: FontWeight.w400),
          ),
          Text(
            day,
            style: Styles.basicTextStyle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
          ),
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
              ),
              Positioned(
                top: double.parse(temp) <= 0
                    ? _fastAnimation.value
                    : _smoothAnimation.value,
                child: _buildWeatherIconWidget(
                  double.parse(temp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIconWidget(double temp) {
    if (temp >= 10) {
      return Positioned(
        child: Icon(
          Icons.wb_sunny,
          color: AppColors.sun,
        ),
      );
    } else if (temp > 0 && temp < 10) {
      return Icon(
        Icons.cloud,
        color: AppColors.cloud,
      );
    } else {
      return Icon(
        Icons.ac_unit_rounded,
        color: AppColors.snow,
      );
    }
  }

  void _onDetectLocationPressed() async {
    _updateLoading();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    LocationWeather locationWeather = await repo.getLocationWeather(position.latitude, position.longitude);
    locationWeather.location = Location("Your location", position.latitude.toString(), position.longitude.toString());
    setState(() {
      locations.add(locationWeather);
    });
    _updateLoading();
  }

  void _onSelectLocationPressed() async {
    var location = await Navigator.pushNamed(context, LocationsScreen.route);
    if (location != null && location is Location) {
      LocationWeather locationWeather = await repo.getLocationWeather(double.parse(location.lat), double.parse(location.lng));
      locationWeather.location = location;
      setState(() {
        locations.add(locationWeather);
      });
    }
  }

  void _updateLoading() {
    setState(() {
      loading = !loading;
    });
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
