import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';

class UserReportMobile extends StatefulWidget {
  final User user;
  const UserReportMobile(this.user);

  @override
  _UserReportMobileState createState() => _UserReportMobileState();
}

class _UserReportMobileState extends State<UserReportMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  User admin;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getAdminUser();
  }

  void _getAdminUser() async {
    admin = await Prefs.getUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int userType = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'User Editor',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            child: Column(
              children: [
                Text(
                  widget.user == null ? 'New User' : 'Edit User',
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
            preferredSize: Size.fromHeight(100),
          ),
        ),
        backgroundColor: Colors.brown[100],
        body: Stack(
          children: [
            Center(
              child: Text(
                'User Report',
                style: Styles.blueBoldLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
