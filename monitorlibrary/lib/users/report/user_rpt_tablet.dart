import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class UserReportTablet extends StatefulWidget {
  final User user;

  UserReportTablet(this.user);

  @override
  _UserReportTabletState createState() => _UserReportTabletState();
}

class _UserReportTabletState extends State<UserReportTablet>
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
