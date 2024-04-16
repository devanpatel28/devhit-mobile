import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/LoginScreen.dart';
import 'screens/UserDashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<int> getInitialScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Use ?? 0 to handle the case when prefs.getInt returns null
    return prefs.getInt('adminId')==0? prefs.getInt('adminId') ?? 0: prefs.getInt('userId') ??0;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<int>(
        future: getInitialScreen(),
        builder: (context, snapshot) {
          // Check if the future is complete and has data
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            // If userId is not 0, go to UserDashboard, else show LoginScreen
            if (snapshot.data! > 0) {
              return UserDashboard();
            } else {
              return LoginScreen();
            }
          } else {
            // Show loading indicator while waiting for the future to complete
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}
