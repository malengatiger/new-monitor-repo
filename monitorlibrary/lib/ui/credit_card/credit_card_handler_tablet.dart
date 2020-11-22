import 'package:flutter/material.dart';

class CreditCardHandlerTablet extends StatefulWidget {
  @override
  _CreditCardHandlerTabletState createState() =>
      _CreditCardHandlerTabletState();
}

class _CreditCardHandlerTabletState extends State<CreditCardHandlerTablet>
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
