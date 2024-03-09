import 'package:flutter/material.dart';

class ProjectImagesScreen extends StatefulWidget {
  const ProjectImagesScreen({super.key});

  @override
  State<ProjectImagesScreen> createState() => _ProjectImagesScreenState();
}

class _ProjectImagesScreenState extends State<ProjectImagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Icon(Icons.settings,),
          ],
        ),
      ),
    );
  }
}
