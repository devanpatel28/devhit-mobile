import 'dart:convert';
import 'package:devhit_mobile/model/UserTransactionModel.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../API/APIs.dart'; // Assuming APIs.dart holds the userTransById constant

class UserTransController extends GetxController {
  List<UserTransaction> transactions = []; // Store fetched transactions

  Future<List<UserTransaction>?> fetchUserTransaction(int uid) async {
    try {
      final response = await http.post(
        Uri.parse(userTransById),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_id": uid,
        })
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body); // Parse as List<dynamic>
        print("$responseData Transaction data obtained");
        transactions = responseData.map((item) => UserTransaction.fromJson(item)).toList(); // Map to UserTransaction objects
        return transactions;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
