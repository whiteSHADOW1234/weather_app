import 'package:flutter/material.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'extensions.dart';
import 'package:intl/intl.dart';



String sign = String.fromCharCodes(Runes('\u00b0'));

class CurrentWeatherPage extends StatefulWidget {
  final List<Location> locations;
  final BuildContext context;
  const CurrentWeatherPage(this.locations, this.context, {super.key});

  @override
  _CurrentWeatherPageState createState() =>
      _CurrentWeatherPageState(locations, context);
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  final List<Location> locations;
  Location location;
  @override
  final BuildContext context;
  _CurrentWeatherPageState(this.locations, this.context)
      : location = locations[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: ListView(children: <Widget>[
          currentWeatherViews(locations, location, this.context),
        ]));
  }

  void _changeLocation(Location newLocation) {
    setState(() {
      location = newLocation;
    });
  }

  Widget currentWeatherViews(List<Location> locations, Location location, BuildContext context) {
    Weather weather;

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          weather = snapshot.data;
          if (weather == null) {
            return const Text("Error getting weather");
          } else {
            return Column(children: [
              createAppBar(locations, location, context),
              weatherBox(weather),
              weatherDetailsBox(weather),
            ]);
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: getCurrentWeather(location),
    );
  }

  Widget createAppBar(
      List<Location> locations, Location location, BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(left: 20, top: 15, bottom: 15, right: 20),
        margin: const EdgeInsets.only(
            top: 35, left: 15.0, bottom: 15.0, right: 15.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(60)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<Location>(
              value: location,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
                size: 24.0,
                semanticLabel: 'Tap to change location',
              ),
              elevation: 16,
              underline: Container(
                height: 0,
                color: Color.fromARGB(255, 206, 188, 255),
              ),
              onChanged: (Location? newLocation) {
                _changeLocation(newLocation!);
              },
              items:
                  locations.map<DropdownMenuItem<Location>>((Location value) {
                return DropdownMenuItem<Location>(
                  value: value,
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '${value.city.capitalizeFirstOfEach}, ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                            text: '${value.country.capitalizeFirstOfEach}',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ));
  }

  Widget weatherDetailsBox(Weather weather) {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 25, bottom: 25, right: 15),
      margin: const EdgeInsets.only(left: 15, top: 5, bottom: 15, right: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]),
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Container(
                  child: const Text(
                "Wind",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey),
              )),
              Container(
                  child: Text(
                "${weather.wind} km/h",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ))
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Container(
                  child: const Text(
                "Humidity",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey),
              )),
              Container(
                  child: Text(
                "${weather.humidity.toInt()}%",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ))
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Container(
                  child: const Text(
                "Pressure",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey),
              )),
              Container(
                  child: Text(
                "${weather.pressure} hPa",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black),
              ))
            ],
          ))
        ],
      ),
    );
  }

  Widget weatherBox(Weather weather) {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(15.0),
        height: 400.0,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 139, 157, 255),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      ClipPath(
          clipper: Clipper(),
          child: Container(
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.all(15.0),
              height: 400.0,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 215, 123),
                  borderRadius: BorderRadius.all(Radius.circular(20))))),
      Container(
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.all(15.0),
          height: 300.0,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 47),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      getWeatherIcon(weather.icon),
                      Container(
                          margin: const EdgeInsets.all(5.0),
                          child: Text(
                            "${weather.description.capitalizeFirstOfEach}",
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 30,
                                color: Colors.white),
                          )),
                      Container(
                          margin: const EdgeInsets.all(5.0),
                          child: Text(
                            "High:${weather.high.toInt()}${sign} Low:${weather.low.toInt()}${sign}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Color.fromARGB(255, 136, 136, 136)),
                          )),
                    ]),
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 20.0),
                child: Column(children: <Widget>[
                  Container(
                      child: Text(
                    "${weather.temp.toInt()}${sign}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 90,
                        color: Color.fromARGB(255, 111, 111, 111)),
                  )),
                  Container(
                      margin: const EdgeInsets.all(0),
                      child: Text(
                        "Feels like ${weather.feelsLike.toInt()}${sign}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color.fromARGB(255, 111, 111, 111)),
                      )),
                ]),
              )
            ],
          ))
    ]);
  }

  Image getWeatherIcon(String icon) {
    String path = 'assets/icons/';
    String imageExtension = ".png";
    return Image.asset(
      path + icon + imageExtension,
      width: 150,
      height: 150,
    );
  }

  String getTimeFromTimestamp(int timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formatter = new DateFormat('h:mm a');
    return formatter.format(date);
  }

  String getDateFromTimestamp(int timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var formatter = new DateFormat('E');
    return formatter.format(date);
  }

}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // a two third wave on the bottom of the container
    var path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(Clipper oldClipper) => false;
}

Future getCurrentWeather(Location location) async {
  Weather weather;
  String city = location.city;
  String apiKey = "78a13a05f96c6127b0cd35c0e6610ab1";
  var url =
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

  final response = await http.get(
    Uri.parse(url),
  );

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
    return weather;
  }

}
