import 'package:flutter/material.dart';
import 'package:monitorlibrary/ui/credit_card/credit_card_handler_desktop.dart';
import 'package:monitorlibrary/ui/credit_card/credit_card_handler_mobile.dart';
import 'package:monitorlibrary/ui/credit_card/credit_card_handler_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CreditCardHandlerMain extends StatefulWidget {
  @override
  _CreditCardHandlerMainState createState() => _CreditCardHandlerMainState();
}

class _CreditCardHandlerMainState extends State<CreditCardHandlerMain>
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
    return ScreenTypeLayout(
      mobile: CreditCardHandlerMobile(),
      tablet: CreditCardHandlerTablet(),
      desktop: CreditCardHandlerDesktop(),
    );
  }
}
