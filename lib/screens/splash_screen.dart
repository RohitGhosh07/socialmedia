import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kkh_events/screens/loginAndSignup_screen.dart';
import 'package:kkh_events/screens/login_screen.dart';
import 'package:kkh_events/screens/main_main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // builder: (context) => LoginAndSignupScreen(),
          builder: (context) => MainMainScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
          child: Image.asset(
            'assets/images/KKH Events.png', // Replace with your image asset path
            width: 200,
            height: 200,
            fit:
                BoxFit.cover, // Ensures the image fits within the rounded edges
          ),
        ),
      ),
    );
  }
}
