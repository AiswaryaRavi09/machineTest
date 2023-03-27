import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/location/model/location_model.dart';

class LocationScreen extends StatefulWidget {
  final CurrentWeather? currentWeather;

  const LocationScreen({Key? key, required this.currentWeather})
      : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
            ),
            alignment: Alignment.topLeft,
            child: const Text(
              'Find Location',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.only(left: 12),
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Search for more location...",
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 130,
            margin: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xff2AC9B3),
                  Color(0xff29FF96),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(60),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(60),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(1.5, 4.5),
                  blurRadius: 20.0,
                  spreadRadius: 1,
                  color: const Color(0xff29FF96).withAlpha(150),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 30,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.currentWeather?.current?.tempC
                                .toString(),
                            style: const TextStyle(
                              fontFamily: 'MohrRounded',
                              fontWeight: FontWeight.w600,
                              fontSize: 38,
                              height: 0.8,
                            ),
                          ),
                          TextSpan(
                            text: '\n${widget.currentWeather?.location?.name}',
                            style: const TextStyle(
                              fontFamily: 'MohrRounded',
                              fontWeight: FontWeight.w400,
                              fontSize: 28,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Humidity:",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Condition:",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "${widget.currentWeather?.current?.humidity.toString()}",
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${widget.currentWeather?.current?.condition?.text.toString()}",
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white.withOpacity(0.05),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                      ),
                      child: Text(
                        '5-day forecast',
                        style: GoogleFonts.questrial(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        //TODO: change weather forecast from local to api get
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget
                              .currentWeather!.forecast!.forecastday!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildSevenDayForecast(
                              widget.currentWeather!.forecast!.forecastday![0]
                                  .date!,
                              widget.currentWeather!.forecast!.forecastday![index].day!.mintempC!.toInt(),
                              widget.currentWeather!.forecast!.forecastday![index].day!.maxtempF!.toInt(),
                              FontAwesomeIcons.sun,
                              size,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

Widget buildSevenDayForecast(
  String time,
  int minTemp,
  int maxTemp,
  IconData weatherIcon,
  size,
) {
  return Padding(
    padding: EdgeInsets.all(
      size.height * 0.005,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.02,
              ),
              child: Text(
                time,
                style: GoogleFonts.questrial(
                  color: Colors.black,
                  fontSize: size.height * 0.025,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.31,
              ),

              child: FaIcon(
                weatherIcon,
                color: Colors.black,
                size: size.height * 0.03,
              ),
            ),
            Align(
              child: Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.15,
                ),
                child: Text(
                  '$minTemp˚C',
                  style: GoogleFonts.questrial(
                    color: Colors.black38,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                ),
                child: Text(
                  '$maxTemp˚C',
                  style: GoogleFonts.questrial(
                    color: Colors.black,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.black,
        ),
      ],
    ),
  );
}
