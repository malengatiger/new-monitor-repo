import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class UserEditTablet extends StatefulWidget {
  final User user;

  UserEditTablet(this.user);

  @override
  _UserEditTabletState createState() => _UserEditTabletState();
}

class _UserEditTabletState extends State<UserEditTablet>
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
