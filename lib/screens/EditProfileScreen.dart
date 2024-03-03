import 'package:devhit_mobile/controllers/UserController.dart';
import 'package:devhit_mobile/helpers/colors.dart';
import 'package:devhit_mobile/model/userModel.dart';
import 'package:devhit_mobile/screens/UserDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import 'LoginScreen.dart';

class EditProfileScreen extends StatefulWidget {
  final User? currentUser;

  const EditProfileScreen(this.currentUser, {Key? key}) : super(key: key);
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;
  late TextEditingController uName;
  late TextEditingController uEmail;
  late TextEditingController uMob;
  late TextEditingController uAddress;
  UserController userControl = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    uName = TextEditingController(text: widget.currentUser?.userName ?? '');
    uMob = TextEditingController(text: widget.currentUser?.userMobile ?? '');
    uEmail = TextEditingController(text: widget.currentUser?.userEmail ?? '');
    uAddress = TextEditingController(text: widget.currentUser?.userAdress ?? '');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pallete4,
        iconTheme: IconThemeData(color: pallete1),
        centerTitle: true,
        title: Text("Edit Profile",style: primaryStyleBold(context, pallete1, 5),),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: TextField(
                      controller: uName,
                      enabled: isLoading?false:true,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Name",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: TextField(
                      controller: uEmail,
                      enabled: isLoading?false:true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Email",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: TextField(
                      controller: uMob,
                      enabled: isLoading?false:true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Mobile",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.22),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: uAddress,
                      enabled: isLoading?false:true,
                      maxLines: 6,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Address",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15) ),
                                title: Center(
                                    child: Text('Update Profile',style: primaryStyleBold(context, pallete4, 5))
                                ),
                                content: Text("Verify Your Details Once Again",style: primaryStyle(context, pallete3, 3.5),textAlign: TextAlign.center),
                                actions: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                              backgroundColor: pallete4,
                                            ),
                                            onPressed: () async {
                                              Get.back();
                                              setState(() {
                                                isLoading=true;
                                              });
                                              if(await userControl.updateuser(widget.currentUser!.userId,uName.text, uEmail.text, uMob.text, uAddress.text))
                                                {
                                                  setState(() {
                                                    isLoading=false;
                                                  });
                                                  Get.snackbar("Changes Saved","Your Profile Updated Successfully",
                                                    backgroundColor: Colors.green,
                                                    colorText: pallete0,
                                                    duration: Duration(seconds: 2)
                                                  );
                                                  Get.offAll(UserDashboard(), curve: Curves.ease);
                                                }
                                              else
                                                {
                                                  setState(() {
                                                    isLoading=false;
                                                  });
                                                  Get.snackbar("Something Went Wrong","Failed to update profile",
                                                    backgroundColor: Colors.red,
                                                    colorText: pallete0,
                                                      duration: Duration(seconds: 2)
                                                  );
                                                }
                                            },
                                            child: Text('UPDATE',style: primaryStyleBold(context, pallete0, 3.5)),
                                          ),
                                          SizedBox(width: getWidth(context, 0.05),),
                                          ElevatedButton(
                                            onPressed: () => Get.back(),
                                            child: Text('CANCEL',style: primaryStyleBold(context, pallete0, 3.5)),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                              backgroundColor: pallete4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),],
                              ));
                        },
                        child: Text("SAVE CHANGES",style: primaryStyleBold(context, pallete1, 4),))
                  ),
                ],
              ),
            ),
          ),
          if(isLoading)
            customLoading(120)
        ],
      ),
    );
  }
}
