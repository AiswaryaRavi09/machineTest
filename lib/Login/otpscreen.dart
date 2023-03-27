import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/location/location_screen/location_screen.dart';
import '../location/model/location_model.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationcode;
  late String pin;
  final TextEditingController _pinputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: scaffoldkey,
      // appBar: AppBar(
      //   title: const Text("OTP Verification"),
      // ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            "Verify +91 ${widget.phone}",
            style: const TextStyle(
                // color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Pinput(
            controller: _pinputController,
            length: 6,
            toolbarEnabled: false,
            onSubmitted: (pin) async {
              try {
                await FirebaseAuth.instance
                    .signInWithCredential(PhoneAuthProvider.credential(
                        verificationId: _verificationcode, smsCode: pin))
                    .then((value) async {
                  if (value.user != null) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationScreen(
                                  currentWeather: currentWeather,
                                )),
                        (route) => false);
                  }
                });
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
          ),
        ),
      ]),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print("user logged in");
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationcode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationcode = verificationId;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  CurrentWeather? currentWeather;
  double? latitude;

  double? longitude;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    await _verifyPhone();
    final position = await getCurrentLocation();
    latitude = position.latitude;
    longitude = position.longitude;
    currentWeather =
        await getCurrentWeather(latitude: latitude!, longitude: longitude!);
    Future.delayed(const Duration(seconds: 5));
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission are dined');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission are permanently denied, We cannot request');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  getCurrentWeather(
      {required double latitude, required double longitude}) async {
    CurrentWeather? data;
    String baseUrl = "http://api.weatherapi.com";
    String apiKey = "c0dbb6f1794640eeabf103014222805";
    String latitudeLongitude = "${latitude.toString()},${longitude.toString()}";
    String currentLocationUrl =
        "/v1/current.json?key=$apiKey&q=$latitudeLongitude&aqi=no";
    String daysLocationUrl =
        "/v1/forecast.json?key=$apiKey&q=$latitudeLongitude&days=5&aqi=no&alerts=no";
    var dayResponse = await http.get(Uri.parse("$baseUrl$daysLocationUrl"));
    if (dayResponse.statusCode == 200) {
      data = CurrentWeather.fromJson(jsonDecode(dayResponse.body));
    }
    return data;
  }
}
