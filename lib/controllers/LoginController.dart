import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../API/APIs.dart';

class LoginController extends GetxController {
  Future<bool> login(String mobile, String password) async {
    try {
      // Make the API call
      final response = await http.post(
          Uri.parse(validateAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "user_mobile": mobile,
            "user_password" : password
          })
      );

      if (response.statusCode == 200) {

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