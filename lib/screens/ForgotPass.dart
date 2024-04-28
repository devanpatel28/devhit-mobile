import 'dart:math';

import 'package:devhit_mobile/API/APIs.dart';
import 'package:devhit_mobile/controllers/LoginController.dart';
import 'package:devhit_mobile/helpers/textStyle.dart';
import 'package:devhit_mobile/screens/ResetPassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../controllers/UserController.dart';
import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../model/userModel.dart';
import 'UserDashboard.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});
  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController mob = TextEditingController();
  bool isLoading = false;
  bool isSecure = true;
  UserController userControl = Get.put(UserController());
  User? currentUser;
  late String OTP;

  String generateOTP() {
    Random random = new Random();
    int otp = 100000 + random.nextInt(900000); // Generates a random number between 100000 and 999999
    print(otp.toString());
    return otp.toString();
  }
  Future<void> initUserData(String mob) async {
      final User? user = await userControl.fetchusermob(mob);
      if (user != null) {
        setState(() {
          currentUser = user;
          print(currentUser?.userEmail);
        });
      }
      OTP=generateOTP();
      sendEmail(currentUser!.userEmail,currentUser!.userName,OTP);
  }

  Future<void> sendEmail(String email,String name,String code) async {
    String username = 'devan.patel.ict@gmail.com'; // Your Gmail address
    String password = 'yoje lden hssm gybo'; // Your Gmail password
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Devhit Developers') // Your name
      ..recipients.add(email) // Recipient's email address
      ..subject = 'Password Reset Code'
      ..html = '''
      <h3><p>Hello, $name</p></h3>
      <p>Your Password Reset Code is :</p>
      <center><h2>$code</h2></center>
      ''';
    Get.off(EnterOtpScreen(otp: OTP,currentUser: currentUser,),curve: Curves.ease,duration: Duration(seconds: 1));
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (error) {
      print('Error sending email: $error');
    }
  }

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
                    Text("FORGOT PASSWORD",
                        style: TextStyle(
                            color: pallete4,
                            fontFamily: "MainReg",
                            fontWeight: FontWeight.bold,
                            fontSize: getSize(context, 6)
                        )
                    ),
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
                            hintText: "Registered mobile number",
                            border: InputBorder.none
                        ),
                        cursorColor: pallete4,
                      ),
                    ),

                    Container(
                      width: getWidth(context, 0.8),
                      height: getHeight(context, 0.06),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          setState(() {
                            isLoading = true;
                          });
                          if(await userControl.fetchusermob(mob.text) != null)
                          {
                            await initUserData(mob.text);
                            Get.snackbar("Code Send","Password Reset Code Send on your Email \n ${currentUser?.userEmail}",
                              backgroundColor: Colors.green,
                              colorText: pallete0,
                            );
                          }
                          else
                          {
                            Get.snackbar("Not Registered","Your mobile number is not registered !",
                              backgroundColor: Colors.red,
                              colorText: pallete0,
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Text("SENT RESET CODE",
                            style: TextStyle(
                                color: pallete1,
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
          ),
          if(isLoading)
            customLoading(120)
        ],
      ),
    );
  }
}

class EnterOtpScreen extends StatelessWidget {
  final String otp;
  final User? currentUser;
  EnterOtpScreen({required this.otp,required this.currentUser});

  TextEditingController code = TextEditingController();

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
                    SizedBox(
                      height: getHeight(context, 0.005),
                    ),
                    Text("Enter Your Reset Code \n For Verification",
                        style: primaryStyle(context, pallete4, 5),textAlign: TextAlign.center,),
                    Container(
                      width: getWidth(context, 0.8),
                      height: getHeight(context, 0.07),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), border: Border.all(color: pallete4)),
                      child: TextField(
                        controller: code,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: getSize(context, 4.5), fontFamily: "MainReg"),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                            hintText: "XXXXXX",
                            border: InputBorder.none),
                        cursorColor: pallete4,
                      ),
                    ),
                    Container(
                      width: getWidth(context, 0.8),
                      height: getHeight(context, 0.06),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (otp == code.text) {
                            Get.off(ResetPassword(currentUser),curve: Curves.ease,duration: Duration(seconds: 1));
                          } else {
                            Get.snackbar("Not Verified", "Your OTP is invalid", backgroundColor: Colors.red, colorText: pallete0);
                          }
                        },
                        child: Text("VERIFY",
                            style: TextStyle(
                                color: pallete1,
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
          ),
        ],
      ),
    );
  }
}
