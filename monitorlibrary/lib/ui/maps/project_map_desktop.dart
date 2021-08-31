import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';

class ProjectMapDesktop extends StatefulWidget {
  final Project project;
  final List<ProjectPosition> projectPositions;

  ProjectMapDesktop({required this.project, required this.projectPositions});

  @override
  _ProjectMapDesktopState createState() => _ProjectMapDesktopState();
}

class _ProjectMapDesktopState extends State<ProjectMapDesktop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
