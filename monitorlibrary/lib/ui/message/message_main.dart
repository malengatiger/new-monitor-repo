import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/ui/message/message_desktop.dart';
import 'package:monitorlibrary/ui/message/message_mobile.dart';
import 'package:monitorlibrary/ui/message/message_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MessageMain extends StatefulWidget {
  final User user;
  MessageMain({Key key, this.user}) : super(key: key);

  @override
  _MessageMainState createState() => _MessageMainState();
}

class _MessageMainState extends State<MessageMain> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MessageMobile(
        user: widget.user,
      ),
      tablet: MessageTablet(
        user: widget.user,
      ),
      desktop: MessageDesktop(
        user: widget.user,
      ),
    );
  }
}
