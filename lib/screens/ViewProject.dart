import 'dart:io';

import 'package:devhit_mobile/helpers/size.dart';
import 'package:devhit_mobile/screens/ProjectImagesScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/textStyle.dart';
import '../model/projectModel.dart';

class ViewProject extends StatefulWidget {
  final Project? currentProject;
  ViewProject(this.currentProject, {Key? key}) : super(key: key);


  @override
  State<ViewProject> createState() => _ViewProjectState();
}

class _ViewProjectState extends State<ViewProject> {
  late String pName;
  late String pAddress;
  late int pArea;
  late int pResident;
  late String pImage;
  late String pBrochure;
  late String pStatus;
  late int p2BHK;
  late int p3BHK;
  late double pPercent;

  void initState() {
    super.initState();
    pName = widget.currentProject!.proName;
    pAddress = widget.currentProject!.proAddress;
    pArea = widget.currentProject!.proArea;
    pResident = widget.currentProject!.proNoResidence;
    pImage = widget.currentProject!.proImage;
    pBrochure = widget.currentProject!.proBrochure;
    pStatus = widget.currentProject!.proStatus;
    p2BHK = widget.currentProject!.pro2bhk;
    p3BHK = widget.currentProject!.pro3bhk;
    pPercent = widget.currentProject!.proPercent;
  }
  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
  }
  Future<void> downloadFile(String url, String fileName) async {
    await requestPermissions(); // Request permissions before downloading file

    // Get the directory for the Download folder
    final String downloadPath = '/storage/emulated/0/Download/';

    // Create the Download folder if it doesn't exist
    if (!await Directory(downloadPath).exists()) {
      await Directory(downloadPath).create(recursive: true);
    }

    // Extract the file name from the URL if not provided
    if (fileName.isEmpty) {
      fileName = url.split('/').last;
    }

    String filePath = '$downloadPath$fileName';

    Dio dio = Dio();

    try {
      await dio.download(url, filePath);
      Get.snackbar("Success", "File downloaded successfully\n\n CLICK HERE TO VIEW", colorText: Colors.white, backgroundColor: Colors.green,
          onTap: (snack) => OpenFilex.open(filePath),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to download file", colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pallete4,
        iconTheme: IconThemeData(color: pallete1),
        centerTitle: true,
        title: Text("View Project",style: primaryStyleBold(context, pallete1, 5),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: getWidth(context, 0.95),
                height: getHeight(context, 0.425),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: pallete1,),
                child: Center(
                  child: InkWell(
                    onTap: () => Get.to(ProjectImagesScreen(widget.currentProject),curve: Curves.easeInOut,duration: Duration(seconds: 1)),
                    child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: getWidth(context, 0.9),
                        height: getHeight(context, 0.4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: widget.currentProject!=null?
                        Image.network(
                            pImage,
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
                ),
              ),
              customDivider(context, 10, 1, 1),
              Container(
                width: getWidth(context, 0.95),
                height: getHeight(context, 0.1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: pallete1
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      customHeading3(context, "Project Name"),
                      Expanded(child: Center(child: Text(" \" "+pName+" \" ",style: primaryStyleBold(context, pallete3, 4.5),)))
                    ],
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 0.01)),
              Container(
                width: getWidth(context, 0.95),
                height: getHeight(context, 0.12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: pallete1
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      customHeading3(context, "Project Address"),
                      Expanded(child: Center(child: Text(pAddress,style: primaryStyleBold(context, pallete3, 3.5),)))
                    ],
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 0.01)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: getWidth(context, 0.47),
                    height: getHeight(context, 0.1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: pallete1
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          customHeading3(context, "Area"),
                          Expanded(child: Center(child: Text(pArea.toString()+" Square Feet",style: primaryStyleBold(context, pallete3, 4),)))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: getWidth(context, 0.47),
                    height: getHeight(context, 0.1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: pallete1
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          customHeading3(context, "Residence"),
                          Expanded(child: Center(child: Text(pResident.toString()+" Flats",style: primaryStyleBold(context, pallete3, 4),)))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight(context, 0.01)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: getWidth(context, 0.47),
                    height: getHeight(context, 0.1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: pallete1
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          customHeading3(context, "2 BHK"),
                          Expanded(child: Center(child: Text(p2BHK.toString()+" Flats",style: primaryStyleBold(context, pallete3, 4),)))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: getWidth(context, 0.47),
                    height: getHeight(context, 0.1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: pallete1
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          customHeading3(context, "3 BHK"),
                          Expanded(child: Center(child: Text(p3BHK.toString()+" Flats",style: primaryStyleBold(context, pallete3, 4),)))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: getHeight(context, 0.02)),
              Container(
                width: double.infinity,
                height: getHeight(context, 0.06),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: pallete4
                ),
                child: TextButton(
                    onPressed: () => downloadFile(pBrochure, "$pName.pdf"),
                    child: Text("Download Brochure", style: primaryStyleBold(context, pallete1, 4),)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
