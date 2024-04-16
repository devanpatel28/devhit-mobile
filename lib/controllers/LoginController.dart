import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/APIs.dart';
class LoginController extends GetxController {

  Future<bool> login(String mobile, String password) async {
    try {
      print("MOBILE = "+mobile);
      print("PASS = "+password);
      // Make the API call
      print("API = "+validateuserAPI);
      final response = await http.post(
          Uri.parse(validateuserAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "user_mobile": mobile,
            "user_password" : password
          })
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        int userId = responseData[0]['user_id'];
        await prefs.setInt('userId', userId);

        print(userId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<bool> loginAdmin(String mobile, String password) async {
    try {
      print("MOBILE = "+mobile);
      print("PASS = "+password);
      // Make the API call
      print("API = "+validateAdminAPI);
      final response = await http.post(
          Uri.parse(validateAdminAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "admin_mob": mobile,
            "admin_pass": password
          })
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        int userId = responseData[0]['admin_id'];
        await prefs.setInt('adminId', userId);

        print(userId);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}