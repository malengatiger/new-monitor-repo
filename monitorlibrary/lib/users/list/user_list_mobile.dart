import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/users/report/user_rpt_main.dart';
import 'package:page_transition/page_transition.dart';

import '../edit/user_edit_main.dart';

class UserListMobile extends StatefulWidget {
  final User user;
  const UserListMobile(this.user);

  @override
  _UserListMobileState createState() => _UserListMobileState();
}

class _UserListMobileState extends State<UserListMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isBusy = false;
  var _users = List<User>();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() {
      isBusy = true;
    });
    await monitorBloc.getOrganizationUsers(
        organizationId: widget.user.organizationId);
    setState(() {
      isBusy = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<User>>(
          stream: monitorBloc.usersStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _users = snapshot.data;
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Users',
                  style: Styles.whiteSmall,
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      _getData();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _navigateToUserEdit(null);
                    },
                  ),
                ],
                bottom: PreferredSize(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          widget.user.organizationName,
                          style: Styles.whiteBoldSmall,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('User List'),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '${_users.length}',
                              style: Styles.blackBoldLarge,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  preferredSize: Size.fromHeight(120),
                ),
              ),
              backgroundColor: Colors.brown[100],
              body: isBusy
                  ? Center(
                      child: Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (BuildContext context, int index) {
                          var user = _users.elementAt(index);
                          return Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    subtitle: Text(
                                      user.email,
                                      style: Styles.greyLabelSmall,
                                    ),
                                    title: Text(
                                      user.name,
                                      style: Styles.blackBoldSmall,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.create),
                                        onPressed: () {
                                          _navigateToUserEdit(user);
                                        },
                                      ),
                                      SizedBox(
                                        width: 60,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons
                                            .report_gmailerrorred_outlined),
                                        onPressed: () {
                                          _navigateToUserReport(user);
                                        },
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            );
          }),
    );
  }

  void _navigateToUserEdit(User user) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: UserEditMain(user)));
  }

  void _navigateToUserReport(User user) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: UserReportMain(user)));
  }
}
