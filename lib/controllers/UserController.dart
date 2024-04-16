import 'dart:convert';
import 'package:devhit_mobile/model/adminModel.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/APIs.dart';
import '../model/userModel.dart';
class UserController extends GetxController {

  Future<User?> fetchuser(int uid) async {
    try {
      final response = await http.post(
          Uri.parse(userbyidAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "user_id": uid,
          })
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("data obtained");
        return User.fromJson(responseData[0]);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<User?> fetchusermob(String mob) async {
    try {
      final response = await http.post(
          Uri.parse(userbymobAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "user_mobile": mob,
          })
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("data obtained");
        return User.fromJson(responseData[0]);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> updateuser(int uid,String uName,String uEmail,String uMobile,String uAddress) async {
    try {
      final response = await http.post(
          Uri.parse(updateUserAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "user_id":uid,
            "user_name":uName,
            "user_email":uEmail,
            "user_mobile":uMobile,
            "user_address":uAddress
          })
      );

      if (response.statusCode == 200) {
        return true;
        print("data Updated");
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  Future<bool> updateuserpass(int uid,String pass) async {
    try {
      final response = await http.post(
          Uri.parse(updateUserPassAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "user_id":uid,
            "user_password":pass
          })
      );

      if (response.statusCode == 200) {
        return true;
        print("data Updated");
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }



  Future<Admin?> fetchadmin(int uid) async {
    try {
      final response = await http.post(
          Uri.parse(adminbyidAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "admin_id": uid,
          })
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("data obtained");
        return Admin.fromJson(responseData[0]);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}