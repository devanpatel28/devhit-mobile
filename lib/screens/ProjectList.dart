import 'package:devhit_mobile/controllers/ProjectController.dart';
import 'package:devhit_mobile/model/projectModel.dart';
import 'package:devhit_mobile/screens/MyProject.dart';
import 'package:devhit_mobile/screens/ViewProject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../helpers/colors.dart';
import '../helpers/customWidget.dart';
import '../helpers/size.dart';
import '../helpers/textStyle.dart';
import 'AddProject.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  ProjectController projectCTR = Get.put(ProjectController());
  List<Project> projects = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProjectsData();
  }

  Future<void> getProjectsData() async {
    setState(() => isLoading = true);
    try {
      projects = (await projectCTR.fetchAllProjects())!;
      if (projects == null) {
        print("No Projects found."); // Handle null case
      }
    } catch (error) {
      print("Error fetching Projects: $error");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pallete4,
        iconTheme: IconThemeData(color: pallete1),
        centerTitle: true,
        title: Text("Projects",style: primaryStyleBold(context, pallete1, 5),),
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
                    onPressed: () => {
                      Get.to(AddProject(),curve: Curves.easeInOut,duration: Duration(seconds: 1))
                    },
                    child: Text("ADD NEW PROJECT",style: primaryStyleBold(context, pallete1, 4),))
            ),
            Expanded(
              child: isLoading
                  ? customLoading(100)
                  : projects.isEmpty
                  ? Center(child: Text('No Projects found'))
                  : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                                    itemCount: projects.length,
                                    itemBuilder: (context, index) {
                    return InkWell(onTap: (){
                      Get.to(ViewProject(projects[index]));
                    },
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(7),
                        child: Container(
                          decoration: BoxDecoration(
                            color: pallete1,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          width: getWidth(context, 0.95),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: projects!=null?
                                    Image.network(
                                        projects[index].proImage,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if(loadingProgress==null)
                                          {
                                            return child;
                                          }
                                          return Stack(
                                            children: [
                                              Center(child: Text("Loading...",style: primaryStyle(context, pallete4, 3),)),
                                              loadingBar(context, 100, 100, Colors.black12),
                                            ],
                                          );
                                        }
                                    )
                                        :loadingBar(context, 150, 150, Colors.black12)
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 10,left: 10),
                                      child:Center(
                                        child: projects!=null?
                                        Text(projects[index].proName,style: primaryStyleBold(context, pallete4, 5),textAlign: TextAlign.left)
                                            :loadingBar(context, 0.03, 0.45,Colors.black12),
                                      )
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 5,left: 10),
                                      child:Center(
                                        child: projects!=null?
                                        customHeading3(context,"Residences :  "+projects[index].proNoResidence.toString())
                                            :loadingBar(context, 0.03, 0.45,Colors.black12),
                                      )
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 5,left: 10),
                                      child:projects!=null?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          projects[index].pro2bhk>1? customHeading3(context,"2BHK :  "+projects[index].pro2bhk.toString()):Container(),
                                          projects[index].pro2bhk>1? SizedBox(width: getWidth(context, 0.05)):Container(),
                                          projects[index].pro3bhk>1? customHeading3(context,"3BHK :  "+projects[index].pro3bhk.toString()):Container()

                                        ],
                                      )
                                          :loadingBar(context, 0.03, 0.45,Colors.black12)
                                  ),
                                  LinearPercentIndicator(
                                    alignment: MainAxisAlignment.center,
                                    width: getWidth(context, 0.55),
                                    lineHeight: 5.0,
                                    barRadius: Radius.circular(10),
                                    percent: projects!=null?projects[index].proPercent:0,
                                    animation: true,
                                    progressColor: pallete4,
                                    backgroundColor: Colors.black12,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 5,bottom: 15,left: 10),
                                    child: Center(
                                      child: projects!=null?
                                      Text("Status : ${projects[index].proStatus}",style: primaryStyleBold(context, pallete4, 3.5),textAlign: TextAlign.left)
                                          :loadingBar(context, 0.02, 0.4, Colors.black12),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    },
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}