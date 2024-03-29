import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart' as mon;

class ProjectListDesktop extends StatefulWidget {
  final mon.User user;

  ProjectListDesktop(this.user);

  @override
  _ProjectListDesktopState createState() => _ProjectListDesktopState();
}

class _ProjectListDesktopState extends State<ProjectListDesktop>
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
