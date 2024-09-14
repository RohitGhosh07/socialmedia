import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kkh_events/api/UserProvider.dart';
import 'package:kkh_events/screens/loginAndSignup_screen.dart';
import 'package:kkh_events/screens/login_screen.dart';
import 'package:kkh_events/screens/main_main.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () async {
      var userAdapter = UserProvider(); // Create an instance of UserAdapter
      bool exists = await userAdapter.userExists(); // Call userExists

      if (exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainMainScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginAndSignupScreen(),
          ),
        );
      }
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
            'assets/images/naiyo.png', // Replace with your image asset path
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
