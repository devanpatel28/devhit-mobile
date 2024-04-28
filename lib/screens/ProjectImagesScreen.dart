import 'dart:io';
import 'package:devhit_mobile/helpers/customWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:devhit_mobile/model/projectModel.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/colors.dart';
import '../helpers/textStyle.dart';

class ProjectImagesScreen extends StatefulWidget {
  final Project? currentProject;
  const ProjectImagesScreen(this.currentProject, {Key? key}) : super(key: key);

  @override
  State<ProjectImagesScreen> createState() => _ProjectImagesScreenState();
}

class _ProjectImagesScreenState extends State<ProjectImagesScreen> {
  late String pName;
  late List<String> imageUrls = [];
  late List<DateTime> modifiedDates = [];
  bool isLoading= false;
  @override
  void initState() {
    super.initState();
    pName = widget.currentProject!.proName;
    fetchImages();
  }

  void fetchImages() async {
    setState(() {isLoading=true;});
    var folderRef = FirebaseStorage.instance.ref().child('project_images/$pName');
    var items = await folderRef.listAll();
    await Future.forEach(items.items, (Reference ref) async {
      var url = await ref.getDownloadURL();
      var metadata = await ref.getMetadata();
      setState(() {
        imageUrls.add(url);
        modifiedDates.add(metadata.updated ?? DateTime.now());
      });
    });
    setState(() {isLoading=false;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pallete4,
        iconTheme: IconThemeData(color: pallete1),
        centerTitle: true,
        title: Text("Project Images",style: primaryStyleBold(context, pallete1, 5),),
      ),
      body: isLoading
          ? customLoading(100)
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                borderOnForeground: true,
                color: pallete0,
                elevation: 5,
                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(imageUrls[index],fit: BoxFit.cover,),
                    ),
                    SizedBox(height: 10),
                    Text('Uploaded on ${DateFormat('dd-MM-yyyy').format(modifiedDates[index])}',
                      style: primaryStyle(context, pallete4, 3),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
