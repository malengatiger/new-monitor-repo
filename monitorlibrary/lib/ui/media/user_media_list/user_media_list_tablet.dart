import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class UserMediaListTablet extends StatefulWidget {
  final User user;

  UserMediaListTablet(this.user);

  @override
  _UserMediaListTabletState createState() => _UserMediaListTabletState();
}

class _UserMediaListTabletState extends State<UserMediaListTablet>
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
