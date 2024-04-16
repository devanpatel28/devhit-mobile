import 'dart:io';
import 'package:devhit_mobile/screens/AdminDashboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hovering/hovering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/ProjectController.dart';
import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import 'UserDashboard.dart';
class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  late TextEditingController pName = TextEditingController();
  late TextEditingController pAddress = TextEditingController();
  late TextEditingController pArea = TextEditingController();
  late TextEditingController pResident = TextEditingController();
  late TextEditingController p2bhk = TextEditingController();
  late TextEditingController p3bhk = TextEditingController();


  String? selectedImageFileName;
  File? selectedImageFile;
  File? selectedPdfFile;
  String? selectedPdfFileName;
  String? downloadPDFURL;
  String? downloadIMGURL;
  bool isLoading = false;
  ProjectController projectControl = Get.put(ProjectController());

  Future<void> _selectPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedPdfFileName = result.files.single.name;
        selectedPdfFile = File(result.files.single.path!); // Get the file name
      });
    }
  }
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImageFile = File(pickedFile.path);
        selectedImageFileName = pickedFile.path.split('/').last; // Get file name
      });
    }
  }
  Future<void> _uploadDetails()async {
    await projectControl.addProject(pName.text, pAddress.text, int.parse(pArea.text), int.parse(pResident.text), int.parse(p2bhk.text), int.parse(p3bhk.text), downloadPDFURL!, downloadIMGURL!);
  }

  Future<void> _uploadFiles() async {
    setState(() {
      isLoading = true;
    });
    if (selectedPdfFile != null) {
      TaskSnapshot pdfTask = await FirebaseStorage.instance
          .ref('project_pdf/${pName.text}.pdf')
          .putFile(selectedPdfFile!);

      // Get download URL of the uploaded PDF file
      downloadPDFURL = await pdfTask.ref.getDownloadURL();

      print("PDF UPLOAD SUCCESS");
    }

    if (selectedImageFile != null) {
      // Upload image file to Firebase Storage
      TaskSnapshot imgTask = await FirebaseStorage.instance
          .ref('project_images/${pName.text}/${pName.text}_1.png')
          .putFile(selectedImageFile!);

      // Get download URL of the uploaded image file
      downloadIMGURL = await imgTask.ref.getDownloadURL();

      print("IMAGE UPLOAD SUCCESS");
    }
    await _uploadDetails();

    setState(() {
      isLoading = false;
    });
    // Display success message
    Get.snackbar("Success", "New Project Added Successfully",
        backgroundColor: Colors.green, colorText: Colors.white);
    Get.offAll(AdminDashboard(), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pallete4,
        iconTheme: IconThemeData(color: pallete1),
        centerTitle: true,
        title: Text("Add Project",style: primaryStyleBold(context, pallete1, 5),),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  customHeading3(context,"Project Name"),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.07),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    child: TextField(
                      controller: pName,
                      enabled: isLoading?false:true,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Project Name",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),

                  customHeading3(context,"Project Address"),
                  Container(
                    width: double.infinity,
                    height: getHeight(context, 0.22),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: pallete4)
                    ),
                    padding: EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: pAddress,
                      enabled: isLoading?false:true,
                      maxLines: 6,
                      style: TextStyle(
                          fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Project Address",
                          border: InputBorder.none
                      ),
                      cursorColor: pallete4,
                    ),
                  ),
                  SizedBox(height: getHeight(context, 0.02),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customHeading3(context,"Project Area"),
                          Container(
                            width: getWidth(context, 0.45),
                            height: getHeight(context, 0.07),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: pallete4)
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: pArea,
                              enabled: isLoading?false:true,
                              style: TextStyle(
                                  fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  hintText: "Project Area",
                                  border: InputBorder.none
                              ),
                              cursorColor: pallete4,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customHeading3(context,"No. Residence"),
                          Container(
                            width: getWidth(context, 0.45),
                            height: getHeight(context, 0.07),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: pallete4)
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: pResident,
                              enabled: isLoading?false:true,
                              style: TextStyle(
                                  fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  hintText: "No. Residence",
                                  border: InputBorder.none
                              ),
                              cursorColor: pallete4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: getHeight(context, 0.02),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customHeading3(context,"2 BHK"),
                          Container(
                            width: getWidth(context, 0.45),
                            height: getHeight(context, 0.07),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: pallete4)
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: p2bhk,
                              enabled: isLoading?false:true,
                              style: TextStyle(
                                  fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  hintText: "2 BHK",
                                  border: InputBorder.none
                              ),
                              cursorColor: pallete4,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customHeading3(context,"3 BHK"),
                          Container(
                            width: getWidth(context, 0.45),
                            height: getHeight(context, 0.07),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: pallete4)
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: p3bhk,
                              enabled: isLoading?false:true,
                              style: TextStyle(
                                  fontSize: getSize(context, 4.5),fontFamily: "MainReg"),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  hintText: "3 BHK",
                                  border: InputBorder.none
                              ),
                              cursorColor: pallete4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: getHeight(context, 0.02),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _selectPDF, // Call function to select PDF
                        child: Container(
                          width: getWidth(context, 0.45),
                          height: getWidth(context, 0.45),
                          decoration: BoxDecoration(
                            border: Border.all(color: pallete4),
                            borderRadius: BorderRadius.circular(5),
                            color: pallete1,
                          ),
                          child: Center(
                            child: selectedPdfFileName != null
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset("assets/images/pdf.png",width: 50),
                                    Text(selectedPdfFileName!, style: primaryStyleBold(context, pallete4, 3.5),),
                                  ],
                                )
                                : Text(
                              "UPLOAD BROCHURE",
                              style: primaryStyleBold(context, pallete4, 3.5),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _selectImage,
                        child: Container(
                          width: getWidth(context, 0.45),
                          height: getWidth(context, 0.45),
                          decoration: BoxDecoration(
                            border: Border.all(color: pallete4),
                            borderRadius: BorderRadius.circular(5),
                            color: pallete1,
                          ),
                          child: selectedImageFile != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              selectedImageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Center(
                            child: Text(
                              selectedImageFileName != null
                                  ? selectedImageFileName!
                                  : "UPLOAD IMAGE",
                              style: primaryStyleBold(context, pallete4, 3.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: getHeight(context, 0.02),),

                  Container(
                      width: double.infinity,
                      height: getHeight(context, 0.07),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: pallete4
                      ),
                      child: TextButton(
                          onPressed: () => _uploadFiles(),
                          child: Text("ADD PROJECT",style: primaryStyleBold(context, pallete1, 4),))
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
