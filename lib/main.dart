import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kkh_events/storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:kkh_events/screens/splash_screen.dart';
import 'providers/image_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(Storage()).initStorage();
  await Hive.initFlutter(); // Initialize Hive for Flutter
  await Hive.openBox('userBox'); // Open a box for user data
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppImageProvider()),
        // ChangeNotifierProvider(
        //     create: (_) =>
        //         UserProvider()..loadUserData()), // Add UserProvider here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KKH Events',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      navigatorObservers: [ClearFocusOnPush()],
    );
  }
}

class ClearFocusOnPush extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}
