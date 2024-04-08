import 'package:devhit_mobile/screens/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';

import '../controllers/UserController.dart';
import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import '../model/userModel.dart';

class ResetPassword extends StatefulWidget {
  final User? currentUser;

  const ResetPassword(this.currentUser, {Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool isSecure =true;
  bool isLoading = false;
  TextEditingController pass = TextEditingController();
  UserController userControl = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pallete0,
      body: Stack(
        children: [
          Center(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: getHeight(context, 0.5),
                    width: getWidth(context, 0.9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: getHeight(context, 0.005),
                        ),
                        Text("Enter Your New Password",
                          style: primaryStyle(context, pallete4, 5),textAlign: TextAlign.center,),
                        Container(
                          width: getWidth(context, 0.8),
                          height: getHeight(context, 0.07),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: pallete4)
                          ),
                          child: TextField(
                            controller: pass,
                            obscureText: isSecure,
                            enabled: isLoading?false:true,
                            style: TextStyle(
                                fontSize: getSize(context, 4.5),
                                fontFamily: "MainReg"),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        isSecure = !isSecure;
                                      });
                                    },
                                    icon: Icon(
                                        isSecure? CupertinoIcons.eye_slash_fill:CupertinoIcons.eye_solid,
                                        opticalSize: 10,
                                        color: isSecure?Colors.grey:pallete4
                                    )
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                hintText: "Password",
                                border: InputBorder.none
                            ),
                            cursorColor: pallete4,
                          ),
                        ),
                        Container(
                          width: getWidth(context, 0.8),
                          height: getHeight(context, 0.06),
                          child: ElevatedButton(
                            onPressed: () async {
                              if(pass.text.length>=8)
                                {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (await userControl.updateuserpass(widget.currentUser!.userId, pass.text)) {
                                    Get.snackbar("Password Updated", "Your Password Updated Successfully!", backgroundColor: Colors.green, colorText: pallete0);
                                    Get.offAll(LoginScreen(),curve: Curves.ease,duration: Duration(seconds: 1));
                                  } else {
                                    Get.snackbar("Something Went Wrong", "", backgroundColor: Colors.red, colorText: pallete0);
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              else
                                {
                                  Get.snackbar("Invalid Password","Password must have 8 characters",  backgroundColor: Colors.red, colorText: pallete0,snackPosition: SnackPosition.BOTTOM);
                                }
                            },
                            child: Text("Confirm",
                                style: TextStyle(
                                    color: pallete0,
                                    fontSize: getSize(context, 5),
                                    fontFamily: "MainReg")),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: pallete4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if(isLoading)
                  customLoading(120)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
