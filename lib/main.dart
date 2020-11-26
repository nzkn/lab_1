import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/blocs/blocs.dart';
import 'package:lab_1/ui/screens/home_screen.dart';

import 'ui/screens/locations_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String initialRoute = HomeScreen.route;
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(),
        ),
        BlocProvider<LocationsBloc>(
          create: (context) => LocationsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: MaterialColor(
            0xFF8D4AE9,
            <int, Color>{
              50: Color(0xFFEDE7F6),
              100: Color(0xFFD1C4E9),
              200: Color(0xFFB39DDB),
              300: Color(0xFF9575CD),
              400: Color(0xFF7E57C2),
              500: const Color(0xFF8D4AE9),
              600: Color(0xFF5E35B1),
              700: Color(0xFF512DA8),
              800: Color(0xFF4527A0),
              900: Color(0xFF311B92),
            },
          ),
          primaryColor: const Color(0xFF8D4AE9),
          cursorColor: const Color(0xFF8D4AE9),
        ),
        initialRoute: initialRoute,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case HomeScreen.route:
        page = HomeScreen();
        break;
      case LocationsScreen.route:
        page = LocationsScreen();
        break;
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (context) => page,
    );
  }
}

