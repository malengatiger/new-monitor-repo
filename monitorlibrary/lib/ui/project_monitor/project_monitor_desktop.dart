import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';

class ProjectMonitorDesktop extends StatefulWidget {
  final Project project;

  const ProjectMonitorDesktop(this.project);
  @override
  _ProjectMonitorDesktopState createState() => _ProjectMonitorDesktopState();
}

class _ProjectMonitorDesktopState extends State<ProjectMonitorDesktop>
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
