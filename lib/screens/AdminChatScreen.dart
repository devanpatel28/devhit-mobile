import 'dart:async';

import 'package:devhit_mobile/helpers/customWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../controllers/ProjectController.dart';
import '../helpers/colors.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import '../model/projectModel.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({super.key});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  Project? selectedProject;
  ProjectController projectControl = Get.put(ProjectController());
  List<Project> projects = [];
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    getProjectsData();
  }
  bool _onMessageChanged() {
    return _messageController.text.isEmpty;
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    _messageController.clear();

    final CollectionReference messagesCollection = FirebaseFirestore.instance.collection('chats');

    final Map<String, dynamic> messageData = {
      'content': message,
      'date': FieldValue.serverTimestamp(),
      'project': selectedProject!.pId,

    };
    // Add the message data to Firestore
    final docRef = await messagesCollection.add(messageData);

    // Additional actions after message is sent, like scrolling to bottom, etc.
  }

  Future<void> getProjectsData() async {
    setState(() {isLoading=true;});
    try {
      projects = (await projectControl.fetchAllProjects())!;
      print("After Query : $projects");
      projects.add(Project(pId: 0, proName: 'BROADCAST', proAddress: '', proArea: 0, proNoResidence: 0, proBrochure: '', proImage: '', proStatus: '', pro2bhk: 0, pro3bhk: 0, proPercent: 0.1));
      print("After Add : $projects");
    } catch (error) {
      print("Error fetching Projects: $error");
    } finally {

    }
    setState(() {isLoading=false;});
  }
  void onProjectSelected(Project? project) {
    setState(() {
      selectedProject = project;
      print(selectedProject!.pId);
    });
  }
  Future<String?> projectName(int pID)
  async {
    Project? pr = await projectControl.fetchProject(pID);

    return pr?.proName;
  }
  TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pallete0,
      appBar: AppBar(
        backgroundColor: pallete4,
        iconTheme: IconThemeData(color: pallete1),
        centerTitle: true,
        title: Text("Chats", style: primaryStyleBold(context, pallete1, 5)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('project')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No chats available'));
          }

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FutureBuilder<String?>(
                            future: projectName(data['project']),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              String projectName = snapshot.data ?? 'Unknown Project';
                              return Container(
                                decoration: BoxDecoration(
                                  color: data['project'] == 0 ? Colors.blue[100] : Colors.green[100],
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      data['project'] == 0
                                          ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.broadcast_on_personal, color: pallete2, size: 15),
                                          Text(" Broadcast", style: primaryStyleBold(context, pallete2, 3)),
                                        ],
                                      )
                                          : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(CupertinoIcons.building_2_fill, color: pallete3, size: 15),
                                          Text(" "+projectName, style: primaryStyleBold(context, pallete3, 3)),
                                        ],
                                      ),
                                      Text(data['content'], style: primaryStyle(context, pallete4, 4.5)),
                                    ],
                                  ),
                                  subtitle: Text(
                                    DateFormat('dd-MM-yyyy, HH:mm').format(data['date'].toDate()),
                                    style: primaryStyle(context, Colors.black38, 2.5),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                    child: Container(
                      width: double.infinity,
                      height: getHeight(context, 0.07),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200],
                          border: Border.all(color: pallete4)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        child: DropdownButton<Project>(
                          value: selectedProject ?? projects.last,
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
                                style: primaryStyleBold(context,project.pId==0?pallete3:pallete4, 4), // Style for the dropdown item text
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: pallete4)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type your message...',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>_onMessageChanged() ? null : _sendMessage(),
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if(isLoading)
                customLoading(50),
            ],
          );
        },
      ),
    );
  }
}
