import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/blocs/blocs.dart';
import 'package:lab_1/models/location.dart';
import 'package:lab_1/ui/resources/resources.dart';

class LocationsScreen extends StatefulWidget {
  static const String route = "/locations";

  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  TextEditingController _locationController;

  @override
  void initState() {
    _locationController = TextEditingController(text: "Lviv");
    BlocProvider.of<LocationsBloc>(context).add(GetLocationsEvent(_locationController.text));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Pick location",
            style: Styles.headerTextStyle.copyWith(color: AppColors.white),
          ),
        ),
        body: BlocBuilder<LocationsBloc, LocationsState>(
            builder: (context, state) {
          if (state is LocationsLoadedState) {
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    suffixIcon: InkWell(
                      onTap: _onSearchTap,
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: state.locations.length,
                  itemBuilder: (context, index) {
                    return _buildLocationWidget(state.locations[index], context);
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColors.primary3,
                    );
                  },
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        ),
      ),
    );
  }

  Widget _buildLocationWidget(Location location, BuildContext context) {
    return InkWell(
      onTap: () => _onLocationTap(context, location),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              location.name,
              style: Styles.basicTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  void _onLocationTap(BuildContext context, Location location) {
    Navigator.pop(context, location);
  }

  void _onSearchTap() {
    context.read<LocationsBloc>().add(GetLocationsEvent(_locationController.text));
  }
}
