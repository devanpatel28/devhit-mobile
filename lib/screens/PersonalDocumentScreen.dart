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

class PersonalDocumentScreen extends StatefulWidget {
  final String? userId;
  const PersonalDocumentScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<PersonalDocumentScreen> createState() => _PersonalDocumentScreenState();
}

class _PersonalDocumentScreenState extends State<PersonalDocumentScreen> {
  bool isLoading = false;
  double uploadProgress = 0.0;
  bool isListEmpty = false;

  Future<List<Map<String, dynamic>>> listFiles() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await FirebaseStorage.instance.ref('personal_documents').listAll();
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
  Future<void> deleteFile(String fileName) async {
    String filePath = 'personal_documents/${widget.userId!}_$fileName';
    try {
      await FirebaseStorage.instance.ref(filePath).delete();
      Get.snackbar("Success", "File deleted Successfully",
          colorText: Colors.white, backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete file",
          colorText: Colors.white, backgroundColor: Colors.red);
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
      Get.snackbar("Success", "File downloaded Successfully", colorText: Colors.white, backgroundColor: Colors.green,
          onTap: (snack) => OpenFilex.open(filePath)
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to download file", colorText: Colors.white, backgroundColor: Colors.red);
    }
  }



  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      File file = File(result.files.single.path!);
      String ext = path.extension(result.files.single.path!);
      String fileName = "${widget.userId}_${DateFormat('HHmmss').format(DateTime.now())}$ext";
      String filePath = 'personal_documents/$fileName';
      try {
        setState(() {
          isLoading = true;
        });
        UploadTask task = FirebaseStorage.instance.ref(filePath).putFile(file);

        // Listen for changes in the upload task
        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            uploadProgress = (snapshot.bytesTransferred / snapshot.totalBytes)*100;
          });
        }, onError: (e) {
          // Handle any errors
        });

        // Wait for upload to complete
        await task;

        Get.snackbar("Success", "File Uploaded Successfully", backgroundColor: Colors.green, colorText: Colors.white);
      } on FirebaseException catch (e) {
        Get.snackbar("Error", "Failed to upload file: ${e.message}", backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
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
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: getHeight(context, 0.07),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: pallete4
              ),
              child: TextButton(
                  onPressed: isLoading ? null : uploadFile,
                  child: Text(isLoading?"UPLOADING...${uploadProgress.floor()}%":"UPLOAD", style: primaryStyleBold(context, pallete1, 4.5),)
              ),
            ),
            SizedBox(height: 10,),
            customHeading(context, "Your Documents"),
            Expanded(
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Image.asset(
                                        "assets/images/download.png",
                                        width: 30,
                                        alignment: Alignment.center,
                                      ),
                                      onPressed: () => downloadFile(file['url'], file['name'], file['type']),
                                    ),
                                    SizedBox(width: 5),
                                    IconButton(
                                      icon: Image.asset(
                                        "assets/images/delete.png",
                                        width: 25,
                                        alignment: Alignment.center,
                                      ),
                                      onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15) ),
                                                title: Center(
                                                    child: Text('Delete Document',style: primaryStyleBold(context, pallete4, 5))
                                                ),
                                                content: Text("Are you sure want to delete this document ?",style: primaryStyle(context, pallete3, 4),textAlign: TextAlign.center),
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
                                                            onPressed: () {setState(() {
                                                              deleteFile(file['name']);
                                                              Get.back();
                                                            });},
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
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
