import 'dart:io';
import 'package:devhit_mobile/controllers/UserController.dart';
import 'package:devhit_mobile/screens/AdminDashboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hovering/hovering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../controllers/ProjectController.dart';
import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import '../model/projectModel.dart';
import 'UserDashboard.dart';
class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late TextEditingController uFname = TextEditingController();
  late TextEditingController uLname = TextEditingController();
  late TextEditingController uEmail = TextEditingController();
  late TextEditingController uMobile = TextEditingController();
  List<Project> projects = [];

  String? selectedImageFileName;
  File? selectedImageFile;
  File? selectedPdfFile;
  String? selectedPdfFileName;
  String? downloadPDFURL;
  String? downloadIMGURL;
  bool isLoading = false;
  ProjectController projectControl = Get.put(ProjectController());
  UserController userController = Get.put(UserController());
  Project? selectedProject;
  @override
  void initState() {
    super.initState();
    getProjectsData();
  }


  void onProjectSelected(Project? project) {
    setState(() {
      selectedProject = project;
      print(selectedProject!.pId);
    });
  }

  Future<void> sendEmail(String email,String name,String uname,String upwd) async {
    String username = 'devan.patel.ict@gmail.com'; // Your Gmail address
    String password = 'yoje lden hssm gybo'; // Your Gmail password
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Devhit Developers') // Your name
      ..recipients.add(email) // Recipient's email address
      ..subject = 'Welcome to Devhit Family'
      ..html = '''
      <h3><p>Hello, $name</p></h3>
      <p>Your login credential for Devhit App is as below</p>
      <b>Username : </b> $uname <br>
      <b>Password : </b> $upwd <br>
      ''';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  Future<void> getProjectsData() async {
    setState(() => isLoading = true);
    try {
      projects = (await projectControl.fetchAllProjects())!;
      if (projects == null) {
        print("No Projects found."); // Handle null case
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
        title: Text("Add New User",style: primaryStyleBold(context, pallete1, 5),),
      ),
      body: Stack(
        children: [
          isLoading?
            customLoading(120):
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  customHeading3(context,"Firstname"),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: TextField(
                      controller: uFname,
                      enabled: isLoading?false:true,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Firstname",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),

                  customHeading3(context,"Lastname"),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: TextField(
                      controller: uLname,
                      enabled: isLoading?false:true,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Lastname",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),

                  customHeading3(context,"Email"),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: TextField(
                      controller: uEmail,
                      keyboardType: TextInputType.emailAddress,
                      enabled: isLoading?false:true,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Email ID",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),


                  customHeading3(context,"Mobile"),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: TextField(
                      controller: uMobile,
                      enabled: isLoading?false:true,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Mobile Number",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),

                  customHeading3(context, "Select Project"),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                      child: DropdownButton<Project>(
                        value: selectedProject ?? projects.first,
                        isExpanded: true,
                        dropdownColor: pallete0,
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        underline: Container(), // Remove the underline
                        onChanged: onProjectSelected,
                        style: primaryStyleBold(context, pallete4, 4), // Style for the dropdown button text
                        items: projects.map((project) {
                          return DropdownMenuItem<Project>(
                            value: project,
                            child: Text(
                              project.proName,
                              style: primaryStyleBold(context, pallete4, 4), // Style for the dropdown item text
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: getHeight(context, 0.05),),
                  Container(
                      width: double.infinity,
                      height: getHeight(context, 0.07),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: pallete4
                      ),
                      child: TextButton(
                          onPressed: () async {
                            String uFullName = "${uFname.text} ${uLname.text}";
                            String uPassword = "${uFname.text}@${uMobile.text}";
                            setState(() {
                              isLoading=true;
                            });
                            if(await userController.checkusermob(uMobile.text))
                              {
                                setState(() {
                                  isLoading=false;
                                });
                                Get.snackbar("Already Registered","Mobile Number is already registered",
                                    backgroundColor: Colors.red,
                                    colorText: pallete0,
                                    duration: Duration(seconds: 2)
                                );
                              }
                            else{
                              if(await userController.addUser(uFullName,uEmail.text,uMobile.text,uPassword,selectedProject!.pId))
                              {
                                await sendEmail(uEmail.text,uFullName,uMobile.text,uPassword);
                                setState(() {
                                  isLoading=false;
                                });
                                Get.snackbar("New User Added","New User Added Success Successfully",
                                    backgroundColor: Colors.green,
                                    colorText: pallete0,
                                    duration: Duration(seconds: 2)
                                );
                                Get.offAll(AdminDashboard(), curve: Curves.ease);
                              }
                              else
                              {
                                setState(() {
                                  isLoading=false;
                                });
                                Get.snackbar("Something Went Wrong","Failed to add user",
                                    backgroundColor: Colors.red,
                                    colorText: pallete0,
                                    duration: Duration(seconds: 2)
                                );
                              }
                            }
                          },
                          child: Text("ADD USER",style: primaryStyleBold(context, pallete0, 4),))
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
