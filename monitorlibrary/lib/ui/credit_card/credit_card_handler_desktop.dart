import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';

class CreditCardHandlerDesktop extends StatefulWidget {
  final User user;

  const CreditCardHandlerDesktop({Key key, this.user}) : super(key: key);
  @override
  _CreditCardHandlerDesktopState createState() =>
      _CreditCardHandlerDesktopState();
}

class _CreditCardHandlerDesktopState extends State<CreditCardHandlerDesktop>
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
