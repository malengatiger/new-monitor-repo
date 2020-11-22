import 'package:flutter/material.dart';

class CreditCardHandlerDesktop extends StatefulWidget {
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
