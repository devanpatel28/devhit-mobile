import 'dart:convert';
import 'dart:ffi';
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
  Future<bool> addProject(
      String pName,
      String pAddress,
      int pArea,
      int pResidents,
      int p2bhk,
      int p3bhk,
      String pBrochure,
      String pImage) async {
    try {
      final response = await http.post(
          Uri.parse(addProjectAPI),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "project_name": pName,
            "project_address": pAddress,
            "project_area": pArea,
            "pro_no_residence": pResidents,
            "project_image": pImage,
            "project_brochure": pBrochure,
            "pro_status": "Started",
            "pro_2bhk": p2bhk,
            "pro_3bhk": p3bhk,
            "pro_percent": 0.01,
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