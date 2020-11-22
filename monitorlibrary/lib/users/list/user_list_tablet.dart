import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class UserListTablet extends StatefulWidget {
  final User user;

  UserListTablet(this.user);

  @override
  _UserListTabletState createState() => _UserListTabletState();
}

class _UserListTabletState extends State<UserListTablet>
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
