import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hovering/hovering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  List<String> selectedImages = [];
  File? _pickedImage;
  File? _pickedFile;
  Uint8List webImage = Uint8List(8);
  Uint8List? _pdfBytes;
  String? _pdfFileName;
  Future<void> pickImages() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var selected = File(image.path);
      var f = await image.readAsBytes();
      setState(() {
        webImage = f;
        _pickedImage = File('a');
      });
    }
    else {
      print("No image");
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pdfBytes = result.files.first.bytes;
        _pdfFileName = result.files.first.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pallete1,
      body: Padding(
        padding: EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add New Project",style: TextStyle(color: orangeColor1,fontSize: 25,fontFamily: "MainReg",fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: orangeColor3,borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Project Name",
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontFamily: 'MainReg',fontSize: 20,color: orangeColor1),
                        cursorColor: orangeColor2,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(color: orangeColor3,borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        minLines: 4,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: "Address",
                          contentPadding: EdgeInsets.only(left: 10,top: 10),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontFamily: 'MainReg',fontSize: 20,color: orangeColor1),
                        cursorColor: orangeColor2,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(color: orangeColor3,borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        minLines: 3,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: "Details",
                          contentPadding: EdgeInsets.only(left: 10,top: 10),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontFamily: 'MainReg',fontSize: 20,color: orangeColor1),
                        cursorColor: orangeColor2,
                      ),
                    ),
                    SizedBox(height: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 500,
                          decoration: BoxDecoration(color: orangeColor3,borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Total Area (Sq.Ft.)",
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontFamily: 'MainReg',fontSize: 20,color: orangeColor1),
                            cursorColor: orangeColor2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 500,
                          decoration: BoxDecoration(color: orangeColor3,borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Total Flats",
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontFamily: 'MainReg',fontSize: 20,color: orangeColor1),
                            cursorColor: orangeColor2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 500,
                          decoration: BoxDecoration(color: orangeColor3,borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "2 BHK",
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontFamily: 'MainReg',fontSize: 20,color: orangeColor1),
                            cursorColor: orangeColor2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 500,
                          decoration: BoxDecoration(color: orangeColor3,borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "3 BHK",
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontFamily: 'MainReg',fontSize: 20,color: orangeColor1),
                            cursorColor: orangeColor2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => pickImages(),
                          child: HoverAnimatedContainer(
                            height: 150,
                            width: 150,
                            curve: Easing.standard,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: orangeColor3,),
                            hoverDecoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: orangeColor2,width: 2),color: orangeColor3,),
                            child: _pickedImage==null
                                ?Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload,color: orangeColor2,size: 50,),
                                Text("Upload Image",style: primaryStyleBold(context, orangeColor2, 2.5),)],)
                                :Container(clipBehavior: Clip.hardEdge, decoration: BoxDecoration(border: Border.all(color: Colors.green,width: 5),borderRadius: BorderRadius.circular(15)),child: Image.memory(webImage,fit: BoxFit.fill)),
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () => _pickPdf(),
                          child: HoverAnimatedContainer(
                              height: 150,
                              width: 150,
                              curve: Easing.standard,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: orangeColor3,),
                              hoverDecoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: orangeColor2,width: 2),color: orangeColor3,),
                              child: _pdfBytes==null
                                  ?Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload_file  ,color: orangeColor2,size: 50,),
                                  Text("Upload PDF",style: primaryStyleBold(context, orangeColor2, 2.5),)],)
                                  : Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.green,width: 5),borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(Icons.file_present_rounded  ,color: orangeColor2,size: 70,),
                                  Text(_pdfFileName.toString(),textAlign: TextAlign.center,style: TextStyle(color: orangeColor2,fontWeight: FontWeight.bold),)],),
                              )
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (){
                        Get.snackbar("Project","New Project Added !",
                          backgroundColor: orangeColor1,
                          colorText: Colors.white,
                          maxWidth: getWidth(context, 0.8),
                        );
                      },
                      child: Text("Submit",style: primaryStyle(context,Colors.white,5 )),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 50),
                          backgroundColor: orangeColor1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
