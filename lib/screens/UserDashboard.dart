import 'package:devhit_mobile/controllers/UserController.dart';
import 'package:devhit_mobile/screens/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import '../model/userModel.dart';
class UserDashboard extends StatefulWidget {
  UserDashboard({super.key});
  @override
  State<UserDashboard> createState() => _UserDashboardState();
}
String _getGreeting() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour < 12) {
    return "Good Morning";
  } else if (hour < 17) {
    return "Good Afternoon";
  } else if (hour < 21) {
    return "Good Evening";
  } else {
    return "Good Night";
  }
}

class _UserDashboardState extends State<UserDashboard> {
  UserController userControl = Get.put(UserController());
  User? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUserData();
  }
  Future<int?> getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<void> initUserData() async {
    final int? userId = await getUID();
    if (userId != null) {
      final User? user = await userControl.fetchuser(userId);
      if (user != null) {
        setState(() {
          currentUser = user;
        });
      }
    }
  }
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: pallete0,
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                  child: Container(

                  )
              ),
              ElevatedButton(onPressed: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setInt('userId',0);
                Get.offAll(LoginScreen(),curve: Curves.ease);
              }, child: Text("LOGOUT"))
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              if(currentUser==null)
                Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: pallete4,
                    size: 100,
                  ),
                ),
              Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){_scaffoldKey.currentState?.openDrawer();},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome, ",style: primaryStyleBold(context, pallete4, 4)),
                                currentUser!=null?
                                  Text(currentUser!.userName,style: primaryStyleBold(context, pallete3, 4),)
                                    :loadingBar(context, 0.03, 0.45)
                              ],
                            ),
                          ),
                          Text(_getGreeting(),style: primaryStyleBold(context, pallete4, 5),)
                        ],
                      ),
                    ),
                  ),
                  customDivider(context, 2.0, 1, 1),
                  Container(
                    decoration: BoxDecoration(
                      color: pallete1,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30,top: 30,bottom: 20),
                          child: Text("Project Name",style: primaryStyleBold(context, pallete4, 5),textAlign: TextAlign.left),
                        ),
                        LinearPercentIndicator(
                          alignment: MainAxisAlignment.center,
                          width: getWidth(context, 0.9),
                          lineHeight: 20.0,
                          barRadius: Radius.circular(50),
                          percent: 0.5,
                          animation: true,
                          progressColor: pallete4,
                          backgroundColor: Colors.black26,
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text("Status : PLASTER DONE",style: primaryStyleBold(context, pallete4, 3),textAlign: TextAlign.left),
                              SizedBox(height: 5,),
                              Text("Update date : 03 Feb 2024",style: primaryStyleBold(context, pallete4, 3),textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  customDivider(context, 2.0, 1, 1),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: getHeight(context, 1),
                      child: Expanded(
                        child: GridView(
                          padding: EdgeInsets.zero,
                          clipBehavior: Clip.hardEdge,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 1
                          ),
                          scrollDirection: Axis.vertical,
                          children: [
                            custProfCardUser(context,"Property Images", 4.0, CupertinoIcons.photo_on_rectangle,LoginScreen()),
                            custProfCardUser(context,"Property Documents", 4.0, CupertinoIcons.doc_append,LoginScreen()),
                            custProfCardUser(context,"Personal Documents", 4.0,CupertinoIcons.doc_person,LoginScreen()),
                            custProfCardUser(context,"Transaction", 4.0, CupertinoIcons.arrow_right_arrow_left,LoginScreen()),
                            custProfCardUser(context,"Bills Documents", 4.0, CupertinoIcons.doc_text,LoginScreen()),
                            custProfCardUser(context,"Edit Profile", 4.0,CupertinoIcons.profile_circled,LoginScreen()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
