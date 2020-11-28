import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class UserMediaListDesktop extends StatefulWidget {
  final User user;

  UserMediaListDesktop(this.user);

  @override
  _UserMediaListDesktopState createState() => _UserMediaListDesktopState();
}

class _UserMediaListDesktopState extends State<UserMediaListDesktop>
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
