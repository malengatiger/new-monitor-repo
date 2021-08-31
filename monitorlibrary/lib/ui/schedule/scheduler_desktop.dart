import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class SchedulerDesktop extends StatefulWidget {
  final User user;

  SchedulerDesktop(this.user);
  @override
  _SchedulerDesktopState createState() => _SchedulerDesktopState();
}

class _SchedulerDesktopState extends State<SchedulerDesktop>
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
