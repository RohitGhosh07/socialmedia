import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kkh_events/admin/routes/route_generator.dart';
import 'package:kkh_events/admin/routes/routes.dart';
import 'package:kkh_events/admin/storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(Storage()).initStorage();

  runApp(const Admin());
}

class Admin extends StatelessWidget {
  const Admin({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return Sizer(builder: (context, orientation, screenType) {
    return GetMaterialApp(
      title: 'KKH Admin Panel',
      theme: ThemeData.light(),
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
    // });
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
