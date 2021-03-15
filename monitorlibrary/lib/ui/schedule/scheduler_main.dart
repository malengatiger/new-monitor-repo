import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/ui/schedule/scheduler_desktop.dart';
import 'package:monitorlibrary/ui/schedule/scheduler_mobile.dart';
import 'package:monitorlibrary/ui/schedule/scheduler_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SchedulerMain extends StatelessWidget {
  final User user;

  SchedulerMain(this.user);
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: SchedulerMobile(user),
      tablet: SchedulerTablet(user),
      desktop: SchedulerDesktop(user),
    );
  }
}
