import 'dart:convert';
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
}