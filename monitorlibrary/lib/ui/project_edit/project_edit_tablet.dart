import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';

class ProjectEditTablet extends StatefulWidget {
  final Project project;

  ProjectEditTablet(this.project);

  @override
  _ProjectEditTabletState createState() => _ProjectEditTabletState();
}

class _ProjectEditTabletState extends State<ProjectEditTablet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

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
