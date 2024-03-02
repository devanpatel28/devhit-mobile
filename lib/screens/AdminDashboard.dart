import 'package:devhit_mobile/screens/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import 'AddProject.dart';
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  double cardtextSize = 4.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pallete0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: getHeight(context, 1),
                  child: Expanded(
                    child: GridView(
                      padding: EdgeInsets.zero,
                      clipBehavior: Clip.hardEdge,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1
                      ),
                      scrollDirection: Axis.vertical,
                      children: [
                        custProfCardAdmin(context,"Add Project", cardtextSize, CupertinoIcons.house_fill,AddProject()),
                        custProfCardAdmin(context,"Update Project Status", cardtextSize, CupertinoIcons.arrow_up_doc_fill,LoginScreen()),
                        custProfCardAdmin(context,"Inquiries", cardtextSize, Icons.mark_email_unread_rounded,LoginScreen()),
                        custProfCardAdmin(context,"Properties Documents", cardtextSize, CupertinoIcons.tray_arrow_up,LoginScreen()),
                        custProfCardAdmin(context,"Customers Documents", cardtextSize,CupertinoIcons.doc_person,LoginScreen()),
                        custProfCardAdmin(context,"Customers Transaction", cardtextSize, CupertinoIcons.arrow_right_arrow_left,LoginScreen()),
                        custProfCardAdmin(context,"Suppliers Transaction", cardtextSize, CupertinoIcons.arrow_right_arrow_left,LoginScreen()),
                        custProfCardAdmin(context,"Inventory", cardtextSize, Icons.storage_rounded,LoginScreen()),
                        custProfCardAdmin(context,"Bills Documents", cardtextSize, CupertinoIcons.doc_text,LoginScreen()),
                        custProfCardAdmin(context,"Add Advertisement", cardtextSize, Icons.ad_units,LoginScreen()),
                        custProfCardAdmin(context,"Web-Data", cardtextSize, Icons.web_rounded,LoginScreen()),
                        custProfCardAdmin(context,"Edit Profile", cardtextSize,CupertinoIcons.profile_circled,LoginScreen()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
