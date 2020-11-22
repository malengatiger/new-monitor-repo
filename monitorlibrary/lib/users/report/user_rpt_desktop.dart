import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class UserReportDesktop extends StatefulWidget {
  final User user;

  UserReportDesktop(this.user);

  @override
  _UserReportDesktopState createState() => _UserReportDesktopState();
}

class _UserReportDesktopState extends State<UserReportDesktop>
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
