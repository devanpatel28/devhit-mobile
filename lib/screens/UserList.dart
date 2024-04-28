import 'package:devhit_mobile/controllers/ProjectController.dart';
import 'package:devhit_mobile/controllers/UserController.dart';
import 'package:devhit_mobile/model/projectModel.dart';
import 'package:devhit_mobile/model/userModel.dart';
import 'package:devhit_mobile/screens/AddUser.dart';
import 'package:devhit_mobile/screens/MyProject.dart';
import 'package:devhit_mobile/screens/ViewProject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import 'AddProject.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  UserController userController = Get.put(UserController());
  ProjectController projectCTR = Get.put(ProjectController());
  List<User> users = [];
  Project? currentProject;
  bool isLoading = false;
  int? pId;

  @override
  void initState() {
    super.initState();
    getUsersData();
    initProjectData();
  }
  Future<void> initProjectData() async {
    final Project? project = await projectCTR.fetchProject(pId!);
    setState(() {
      currentProject = project;
    });
  }
  Future<void> getUsersData() async {
    setState(() => isLoading = true);
    try {
      users = (await userController.fetchAllusers())!;
      if (users == null) {
        print("No Users found."); // Handle null case
      }
    } catch (error) {
      print("Error fetching Projects: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pallete4,
        iconTheme: IconThemeData(color: pallete1),
        centerTitle: true,
        title: Text("Users",style: primaryStyleBold(context, pallete1, 5),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                height: getHeight(context, 0.07),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: pallete4
                ),
                child: TextButton(
                    onPressed: () => {
                      Get.to(AddUser(),curve: Curves.easeInOut,duration: Duration(seconds: 1))
                    },
                    child: Text("ADD NEW USER",style: primaryStyleBold(context, pallete1, 4),))
            ),
            Expanded(
              child: isLoading
                  ? customLoading(100)
                  : users.isEmpty
                  ? Center(child: Text('No User found'))
                  : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(7),
                      child: ListTile(
                        title: Text(users[index].userName,style: primaryStyle(context, pallete4, 4),),
                        leading: Icon(Icons.person,color: pallete4,),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(FontAwesomeIcons.whatsapp,color: pallete4,),
                              onPressed: () async {
                                final url = 'https://wa.me/+91${users[index].userMobile}';
                                launch(url);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.call,color: pallete4,),
                              onPressed: () => launch('tel:${users[index].userMobile}'),
                            ),
                          ],
                        ),
                      ),
                    );
                    },
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}