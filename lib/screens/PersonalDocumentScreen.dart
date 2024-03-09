import 'dart:io';
import 'package:devhit_mobile/helpers/customWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/colors.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';

class PersonalDocumentScreen extends StatefulWidget {
  final String? userMob;
  const PersonalDocumentScreen(this.userMob, {Key? key}) : super(key: key);

  @override
  State<PersonalDocumentScreen> createState() => _PersonalDocumentScreenState();
}

class _PersonalDocumentScreenState extends State<PersonalDocumentScreen> {
  bool isLoading = false;
  double uploadProgress = 0.0;

  Future<List<Map<String, dynamic>>> listFiles() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await FirebaseStorage.instance.ref('personal_documents').listAll();

    for (var item in result.items) {
      if (item.name.startsWith(widget.userMob!)) {
        String downloadUrl = await item.getDownloadURL();
        files.add({
          'name': item.name,
          'url': downloadUrl,
          'type': item.name.endsWith('.pdf') ? 'pdf' : 'image',
        });
      }
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
      Get.snackbar("Success", "File downloaded to $filePath", colorText: Colors.white, backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", "Failed to download file", colorText: Colors.white, backgroundColor: Colors.red);
    }
  }



  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = "${widget.userMob}_${DateFormat('HHmmss').format(DateTime.now())}";
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
            Container(
              width: double.infinity,
              height: getHeight(context, 0.07),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: pallete4
              ),
              child: TextButton(
                  onPressed: isLoading ? null : uploadFile,
                  child: Text(isLoading?"UPLOADING...${uploadProgress.floor()}%":"UPLOAD", style: primaryStyleBold(context, pallete1, 4),)
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: listFiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return customLoading(100);
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading files"));
                  } else {
                    final files = snapshot.data!;
                    return ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        var file = files[index];
                        return ListTile(
                          leading: Icon(file['type'] == 'pdf' ? Icons.picture_as_pdf : Icons.image),
                          title: Text(file['name']),
                          trailing: IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () => downloadFile(file['url'], file['name'],file['type']),
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
