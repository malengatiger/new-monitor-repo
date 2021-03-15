import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class SchedulerTablet extends StatefulWidget {
  final User user;

  SchedulerTablet(this.user);
  @override
  _SchedulerTabletState createState() => _SchedulerTabletState();
}

class _SchedulerTabletState extends State<SchedulerTablet>
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
