import 'package:devhit_mobile/screens/AdminDashboard.dart';
import 'package:devhit_mobile/screens/LoginScreen.dart';
import 'package:devhit_mobile/screens/UserDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen()
    );
  }
}