import 'package:devhit_mobile/screens/AdminDashboard.dart';
import 'package:devhit_mobile/screens/LoginScreen.dart';
import 'package:devhit_mobile/screens/UserDashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  int adminID = prefs.getInt('adminId') ?? 0;
  int userID = prefs.getInt('userId') ?? 0;

  Widget initialScreen;
  if (adminID>0) {
    initialScreen = AdminDashboard();
  } else if (userID>0) {
    initialScreen = UserDashboard();
  } else {
    initialScreen = LoginScreen();
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  MyApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: initialScreen,
    );
  }
}
