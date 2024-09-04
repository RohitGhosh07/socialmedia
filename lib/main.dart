import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kkh_events/storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:kkh_events/screens/splash_screen.dart';
import 'providers/image_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(Storage()).initStorage();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppImageProvider()),
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
