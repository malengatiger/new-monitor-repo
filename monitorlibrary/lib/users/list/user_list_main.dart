import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/users/list/user_list_desktop.dart';
import 'package:monitorlibrary/users/list/user_list_mobile.dart';
import 'package:monitorlibrary/users/list/user_list_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserListMain extends StatefulWidget {
  UserListMain({Key? key}) : super(key: key);

  @override
  _UserListMainState createState() => _UserListMainState();
}

class _UserListMainState extends State<UserListMain> {
  User? _user;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    setState(() {
      isBusy = true;
    });
    _user = await Prefs.getUser();
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Organization Users Loading'),
                bottom: PreferredSize(
                  child: Column(),
                  preferredSize: Size.fromHeight(100),
                ),
              ),
              body: Center(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                  ),
                ),
              ),
            ),
          )
        : ScreenTypeLayout(
            mobile: UserListMobile(_user!),
            tablet: UserListTablet(_user!),
            desktop: UserListDesktop(_user!),
          );
  }
}
