import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kkh_events/admin/class/login_api_class.dart';
import 'package:kkh_events/admin/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      LoginApiClass.isLoggedIn()
          ? Get.offAllNamed(Routes.dashboard)
          : Get.offAllNamed(Routes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/download.gif'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
