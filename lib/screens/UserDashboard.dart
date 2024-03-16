import 'package:devhit_mobile/controllers/UserController.dart';
import 'package:devhit_mobile/screens/EditProfileScreen.dart';
import 'package:devhit_mobile/screens/LoginScreen.dart';
import 'package:devhit_mobile/screens/MyProject.dart';
import 'package:devhit_mobile/screens/PersonalDocumentScreen.dart';
import 'package:devhit_mobile/screens/ProjectImagesScreen.dart';
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
import 'PropertyDocumentsScreen.dart';
class UserDashboard extends StatefulWidget {
  UserDashboard({super.key});
  @override
  State<UserDashboard> createState() => _UserDashboardState();
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

class _UserDashboardState extends State<UserDashboard> {
  UserController userControl = Get.put(UserController());
  ProjectController projectControl = Get.put(ProjectController());
  User? currentUser;
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
    return prefs.getInt('userId');
  }

  Future<void> initUserData() async {
    final int? userId = await getUID();
    if (userId != null) {
      final User? user = await userControl.fetchuser(userId);
      if (user != null) {
        setState(() {
          currentUser = user;
          initProjectData();
        });
      }
    }
  }
  Future<void> initProjectData() async {
    final int? pId = currentUser?.projectId;
    final Project? project = await projectControl.fetchProject(pId!);
      setState(() {
        currentProject = project;
      });
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
                                  currentUser!.userName[0]:"?",
                                style: primaryStyleBold(context, pallete0, 12),
                              )
                          ),
                        ),
                        currentUser!=null?
                        Text(currentUser!.userName,style: primaryStyleBold(context, pallete3, 4),)
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
                      leading: Icon(Icons.edit,color: pallete4),
                      title: Text("Edit Profile",style: primaryStyleBold(context, pallete4, 4),),
                      onTap: () {
                        Get.to(EditProfileScreen(currentUser),curve: Curves.ease);
                      },
                    ),
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
                                            await prefs.setInt('userId', 0);
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
                                Text("Welcome, ",style: primaryStyleBold(context, pallete4, 4)),
                                currentUser!=null?
                                  Text(currentUser!.userName,style: primaryStyleBold(context, pallete3, 4),)
                                    :loadingBar(context, 0.03, 0.45,pallete1)
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() {initUserData();initProjectData();}),
                              child: Text(_getGreeting(),style: primaryStyleBold(context, pallete4, 4),)
                          )
                        ],
                      ),
                    ),
                  ),
                  customDivider(context, 2.0, 1.5, 1.5),
                  InkWell(onTap: () => Get.to(MyProject(currentProject),curve: Curves.ease),
                    child: Container(
                      decoration: BoxDecoration(
                        color: pallete1,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: getWidth(context, 0.95),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                                width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: currentProject!=null?
                              Image.network(
                                currentProject!.proImage,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if(loadingProgress==null)
                                    {
                                      return child;
                                    }
                                  return Stack(
                                    children: [
                                      Center(child: Text("Loading...",style: primaryStyle(context, pallete4, 3),)),
                                      loadingBar(context, 150, 150, Colors.black12),
                                    ],
                                  );
                                }
                                )
                                  :loadingBar(context, 150, 150, Colors.black12)
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20,bottom: 10,left: 10),
                                child:Center(
                                  child: currentProject!=null?
                                      Text(currentProject!.proName,style: primaryStyleBold(context, pallete4, 5),textAlign: TextAlign.left)
                                      :loadingBar(context, 0.03, 0.45,Colors.black12),
                                )
                              ),
                              LinearPercentIndicator(
                                alignment: MainAxisAlignment.center,
                                width: getWidth(context, 0.45),
                                lineHeight: 12.0,
                                barRadius: Radius.circular(10),
                                percent: currentProject!=null?currentProject!.proPercent:0,
                                animation: true,
                                progressColor: pallete4,
                                backgroundColor: Colors.black12,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 15,bottom: 15,left: 10),
                                child: Center(
                                  child: currentProject!=null?
                                  Text("Status : ${currentProject?.proStatus}",style: primaryStyleBold(context, pallete4, 3.5),textAlign: TextAlign.left)
                                      :loadingBar(context, 0.02, 0.4, Colors.black12),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
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
                            custProfCardUser(context,"Property Images", CupertinoIcons.photo_on_rectangle,ProjectImagesScreen()),
                            custProfCardUser(context,"Property Documents", CupertinoIcons.doc_append,PropertyDocumentsScreen(!currentUser.isNull?currentUser!.userId.toString():"0")),
                            custProfCardUser(context,"Personal Documents", CupertinoIcons.doc_person,PersonalDocumentScreen(!currentUser.isNull?currentUser!.userId.toString():"0")),
                            custProfCardUser(context,"Transaction", CupertinoIcons.arrow_right_arrow_left,UserTransactionScreen(!currentUser.isNull?currentUser!.userId:0)),
                            custProfCardUser(context,"Bills Documents", CupertinoIcons.doc_text,ProjectImagesScreen()),
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
      ),
    );
  }
}
