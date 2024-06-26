import 'dart:io';
import 'package:devhit_mobile/helpers/customWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/colors.dart';
import '../helpers/size.dart';
import 'package:path/path.dart' as path;
import '../helpers/textStyle.dart';

class PropertyDocumentsScreen extends StatefulWidget {
  final String? userId;
  const PropertyDocumentsScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<PropertyDocumentsScreen> createState() => _PropertyDocumentsScreenState();
}

class _PropertyDocumentsScreenState extends State<PropertyDocumentsScreen> {
  bool isLoading = false;
  double uploadProgress = 0.0;
  bool isListEmpty = false;

  Future<List<Map<String, dynamic>>> listFiles() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await FirebaseStorage.instance.ref('property_doc').listAll();
    isListEmpty=false;
    for (var item in result.items) {
      final filenameWithoutPrefix = item.name.substring(widget.userId!.length + 1);
      if (item.name.startsWith(widget.userId!+"_")) {
        String downloadUrl = await item.getDownloadURL();
        files.add({
          'name': filenameWithoutPrefix,
          'url': downloadUrl,
          'type': item.name.endsWith('.pdf') ? 'pdf' : 'image',
        });
      }
    }
    if(files.isEmpty)
    {
      isListEmpty=!isListEmpty;
    }

    return files;
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
  }
  Future<void> downloadFile(String url, String fileName,String ext) async {
    await requestPermissions(); // Request permissions before downloading file

    // Get the directory for the Pictures folder
    final String picturesPath = '/storage/emulated/0/Download/';

    // Create the Pictures folder if it doesn't exist
    if (!await Directory(picturesPath).exists()) {
      await Directory(picturesPath).create(recursive: true);
    }
    String filePath="";
    if(ext=="image")
    {
      filePath = '$picturesPath$fileName.jpg';
    }
    else
    {
      filePath = '$picturesPath$fileName';
    }

    Dio dio = Dio();

    try {
      await dio.download(url, filePath);
      Get.snackbar("Success", "File downloaded Successfully\n\n CLICK HERE TO VIEW", colorText: Colors.white, backgroundColor: Colors.green,
          onTap: (snack) => OpenFilex.open(filePath)
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
        title: Text("Personal Documents", style: primaryStyleBold(context, pallete1, 5),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: listFiles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return customLoading(100);
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading files"));
              }
              else {
                final files = snapshot.data!;
                return isListEmpty?customNoData(context, "You Don't Have Any Document")
                    :ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    var file = files[index];
                    return Card(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.asset(file['type'] == 'pdf' ?"assets/images/pdf.png":"assets/images/image.png",width: 30),
                            title: Text(file['name'],style: primaryStyle(context, pallete4, 4)),
                            trailing: IconButton(
                              icon: Image.asset(
                                "assets/images/download.png",
                                width: 30,
                                alignment: Alignment.center,
                              ),
                              onPressed: () => downloadFile(file['url'], file['name'], file['type']),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
