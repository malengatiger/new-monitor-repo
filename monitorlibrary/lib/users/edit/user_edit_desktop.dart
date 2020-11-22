import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class UserEditDesktop extends StatefulWidget {
  final User user;

  UserEditDesktop(this.user);

  @override
  _UserEditDesktopState createState() => _UserEditDesktopState();
}

class _UserEditDesktopState extends State<UserEditDesktop>
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
