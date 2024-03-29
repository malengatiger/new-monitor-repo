import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class UserListDesktop extends StatefulWidget {
  final User user;

  UserListDesktop(this.user);

  @override
  _UserListDesktopState createState() => _UserListDesktopState();
}

class _UserListDesktopState extends State<UserListDesktop>
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
