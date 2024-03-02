import 'package:devhit_mobile/screens/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

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
  @override
  String username = "Devan";
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pallete0,
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                  child: Container(

                  )
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        children: [
                          Text("Hello, ",style: primaryStyleBold(context, pallete4, 4),),
                          Text(username,style: primaryStyleBold(context, pallete3, 4),)
                        ],
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
        ),
      ),
    );
  }
}
