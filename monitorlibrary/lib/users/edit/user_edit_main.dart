import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/users/edit/user_edit_desktop.dart';
import 'package:monitorlibrary/users/edit/user_edit_mobile.dart';
import 'package:monitorlibrary/users/edit/user_edit_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserEditMain extends StatelessWidget {
  final User user;

  UserEditMain(this.user);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: UserEditMobile(user),
      tablet: UserEditTablet(user),
      desktop: UserEditDesktop(user),
    );
  }
}
