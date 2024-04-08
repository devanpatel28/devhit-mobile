import 'package:devhit_mobile/API/APIs.dart';
import 'package:devhit_mobile/controllers/LoginController.dart';
import 'package:devhit_mobile/helpers/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import 'ForgotPass.dart';
import 'UserDashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mob = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isLoading = false;
  bool isSecure = true;
  LoginController loginControl = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pallete0,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Container(
                height: getHeight(context, 0.5),
                width: getWidth(context, 0.9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: getHeight(context, 0.005),),
                    Text("LOGIN",
                        style: TextStyle(
                            color: pallete4,
                            fontFamily: "MainReg",
                            fontWeight: FontWeight.bold,
                            fontSize: getSize(context, 9)
                        )
                    ),
                    SizedBox(height: getHeight(context, 0.05),),
                    Container(
                      width: getWidth(context, 0.8),
                      height: getHeight(context, 0.07),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: pallete4)
                      ),
                      child: TextField(
                        controller: mob,
                        enabled: isLoading?false:true,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                            hintText: "Mobile number",
                            border: InputBorder.none
                        ),
                        cursorColor: pallete4,
                      ),
                    ),
                    SizedBox(height: 10,),
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
                    SizedBox(height: 20,),
                    Container(
                      width: getWidth(context, 0.8),
                      height: getHeight(context, 0.06),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          setState(() {
                            isLoading = true;
                          });
                          if(await loginControl.login(mob.text,pass.text))
                            {
                              Get.offAll(UserDashboard(),curve: Curves.ease,duration: Duration(seconds: 1));
                            }
                          else
                            {
                              Get.snackbar("Login Failed","Email or Password is invalid",
                                backgroundColor: Colors.red,
                                colorText: pallete0,
                              );
                            }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Text("LOGIN",
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
                    customHeading(context, "OR"),
                    TextButton(onPressed: (){
                      Get.to(ForgotPassScreen(),curve: Curves.ease,duration: Duration(seconds: 1));
                    }, child: Text("Forgot Password ?",style: primaryStyle(context, pallete4, 4),)),
                  ],
                ),
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
