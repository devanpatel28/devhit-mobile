import 'package:devhit_mobile/helpers/customWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../helpers/colors.dart';
import '../helpers/textStyle.dart';
import '../model/projectModel.dart';

class ChatScreen extends StatefulWidget {
  final Project? currentProject;
  const ChatScreen(this.currentProject, {Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late int pid;

  @override
  void initState() {
    super.initState();
    pid = widget.currentProject!.pId;
  }

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
            .where('project', whereIn: [0, widget.currentProject?.pId])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: customLoading(100));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No chats available'));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: data['project']==0?Colors.blue[100]:Colors.green[100],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)
                      )
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        data['project']==0?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.broadcast_on_personal,color: pallete2,size: 15,),
                              Text(" Broadcast", style: primaryStyleBold(context, pallete2, 3)),
                            ],):Container(),
                        Text(data['content'], style: primaryStyle(context, pallete4, 4.5)),
                      ],
                    ),
                    subtitle: Text(
                      DateFormat('dd-MM-yyyy, HH:mm').format(data['date'].toDate()),
                      style: primaryStyle(context, Colors.black38, 2.5),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
