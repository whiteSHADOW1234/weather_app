import 'package:flutter/material.dart';
import 'package:weather/current_weather.dart';
import 'package:weather/models/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<Location> locations = [
    new Location(
        city: "calgary",
        country: "canada",
        lat: "51.0407154",
        lon: "-114.1513999"),
    new Location(
        city: "edmonton",
        country: "canada",
        lat: "53.5365386",
        lon: "-114.1513999")
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CurrentWeatherPage(locations, context),
    );
  }
}