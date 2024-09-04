import 'package:flutter/material.dart';
import 'package:kkh_events/admin/routes/routes.dart';
import 'package:kkh_events/admin/ui/add_edit_event_screen.dart';
import 'package:kkh_events/admin/ui/home_screen.dart';
import 'package:kkh_events/admin/ui/login_screen.dart';
import 'package:kkh_events/admin/ui/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget widgetScreen;

    switch (settings.name) {
      case Routes.dashboard:
        widgetScreen = const HomeScreen();
        break;
      case Routes.login:
        widgetScreen = const LoginScreen();
        break;
      case Routes.splash:
        widgetScreen = const SplashScreen();
        break;
      case Routes.addEditEvent:
        widgetScreen = const AddEditEventScreen();
      default:
        widgetScreen = _errorRoute();
    }

    return PageRouteBuilder(
        settings: settings, pageBuilder: (_, __, ___) => widgetScreen);
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text(
          'No such screen found in route generator',
        ),
      ),
    );
  }
}
