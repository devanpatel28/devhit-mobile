import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../API/APIs.dart';
import '../model/projectModel.dart';
class ProjectController extends GetxController {

  Future<Project?> fetchProject(int pid) async {
    try {
      final response = await http.post(
          Uri.parse(projectByIdAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "project_id": pid,
          })
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("project data obtained");
        return Project.fromJson(responseData[0]);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}