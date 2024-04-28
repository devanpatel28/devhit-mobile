import 'package:devhit_mobile/controllers/UserController.dart';
import 'package:devhit_mobile/model/adminModel.dart';
import 'package:devhit_mobile/screens/AddProject.dart';
import 'package:devhit_mobile/screens/ChatScreen.dart';
import 'package:devhit_mobile/screens/EditProfileScreen.dart';
import 'package:devhit_mobile/screens/LoginScreen.dart';
import 'package:devhit_mobile/screens/MyProject.dart';
import 'package:devhit_mobile/screens/PersonalDocumentScreen.dart';
import 'package:devhit_mobile/screens/ProjectImagesScreen.dart';
import 'package:devhit_mobile/screens/ProjectList.dart';
import 'package:devhit_mobile/screens/UserList.dart';
import 'package:devhit_mobile/screens/UserTransactionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/ProjectController.dart';
import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import '../model/projectModel.dart';
import '../model/userModel.dart';
import 'AdminChatScreen.dart';
import 'PropertyDocumentsScreen.dart';
class AdminDashboard extends StatefulWidget {
  AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}
String _getGreeting() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour < 12) {
    return "Good Morning 🌤️";
  } else if (hour < 17) {
    return "Good Afternoon ☀️";
  } else if (hour < 21) {
    return "Good Evening 🌅";
  } else {
    return "Good Night 🌃";
  }
}

class _AdminDashboardState extends State<AdminDashboard> {
  UserController userControl = Get.put(UserController());
  ProjectController projectControl = Get.put(ProjectController());
  Admin? currentUser;
  Project? currentProject;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUserData();
    if(currentUser.isNull)
      {
        initUserData();
      }
  }
  Future<int?> getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('adminId');
  }

  Future<void> initUserData() async {
    final int? userId = await getUID();
    if (userId != null) {
      final Admin? user = await userControl.fetchadmin(userId);
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
          backgroundColor: pallete1,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: pallete1
                ),
                curve: Curves.ease,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: getSize(context, 25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: pallete4,width: 3),
                            color: pallete3
                          ),
                          child: Center(
                              child: Text(
                                currentUser!=null?
                                  currentUser!.adminName[0]:"?",
                                style: primaryStyleBold(context, pallete0, 12),
                              )
                          ),
                        ),
                        currentUser!=null?
                        Text(currentUser!.adminName,style: primaryStyleBold(context, pallete3, 4),)
                            :loadingBar(context, 0.03, 0.45,pallete1)
                      ],
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout,color: pallete4),
                      title: Text("Logout",style: primaryStyleBold(context, pallete4, 4),),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15) ),
                              title: Center(
                                  child: Text('Logout',style: primaryStyleBold(context, pallete4, 5.5))
                              ),
                              content: Text("Are you sure want to logout?",style: primaryStyle(context, pallete3, 3.5),textAlign: TextAlign.center),
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
                                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                                            await prefs.setInt('adminId', 0);
                                            Get.offAll(LoginScreen(), curve: Curves.ease);
                                          },
                                          child: Text('YES',style: primaryStyleBold(context, pallete0, 3.5)),
                                        ),
                                        SizedBox(width: getWidth(context, 0.05),),
                                        ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: Text('NO',style: primaryStyleBold(context, pallete0, 3.5)),
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
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
                                Text("Welcome Admin, ",style: primaryStyleBold(context, pallete4, 4)),
                                currentUser!=null?
                                  Text(currentUser!.adminName,style: primaryStyleBold(context, pallete2, 4),)
                                    :loadingBar(context, 0.03, 0.45,pallete1)
                              ],
                            ),
                          ),
                          Text(_getGreeting(),style: primaryStyleBold(context, pallete4, 4),)
                        ],
                      ),
                    ),
                  ),
                  customDivider(context, 2.0, 1.5, 1.5),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: getHeight(context, 1),
                      child: Expanded(
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          clipBehavior: Clip.hardEdge,
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2,
                          children: [
                            custProfCardUser(context,"Projects", CupertinoIcons.building_2_fill,ProjectList()),
                            custProfCardUser(context,"Users", CupertinoIcons.person_2_alt,UserList()),
                            custProfCardUser(context,"Messages", CupertinoIcons.chat_bubble_2,AdminChatScreen())
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if(currentUser==null)
                customLoading(120)
            ],
          ),
        ),
      )
    );
  }
}
