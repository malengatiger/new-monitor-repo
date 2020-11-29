import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/ui/credit_card/credit_card_handler_desktop.dart';
import 'package:monitorlibrary/ui/credit_card/credit_card_handler_mobile.dart';
import 'package:monitorlibrary/ui/credit_card/credit_card_handler_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CreditCardHandlerMain extends StatefulWidget {
  final User user;

  const CreditCardHandlerMain({Key key, this.user}) : super(key: key);

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
      mobile: CreditCardHandlerMobile(user: widget.user),
      tablet: CreditCardHandlerTablet(user: widget.user),
      desktop: CreditCardHandlerDesktop(user: widget.user),
    );
  }
}
