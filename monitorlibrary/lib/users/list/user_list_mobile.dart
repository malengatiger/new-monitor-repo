import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:monitorlibrary/bloc/fcm_bloc.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/message/message_main.dart';
import 'package:monitorlibrary/users/report/user_rpt_main.dart';
import 'package:page_transition/page_transition.dart';

import '../../snack.dart';
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
  var _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getData(true);
    _listen();
  }

  void _listen() {
    fcmBloc.userStream.listen((User user) {
      if (mounted) {
        AppSnackbar.showSnackbar(
            scaffoldKey: _key,
            message: 'User has been added OK',
            textColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor);
      }
    });
  }

  void _getData(bool forceRefresh) async {
    setState(() {
      isBusy = true;
    });
    try {
      _users = await monitorBloc.getOrganizationUsers(
          organizationId: widget.user.organizationId,
          forceRefresh: forceRefresh);
      _users.sort((a, b) => (a.name.compareTo(b.name)));
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Organization user refresh failed');
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<IconButton> getIconButtons() {
    List<IconButton> list = [];
    list.add(IconButton(
      icon: Icon(
        Icons.refresh,
        size: 20,
      ),
      onPressed: () {
        _getData(true);
      },
    ));
    if (widget.user.userType == ORG_ADMINISTRATOR) {
      list.add(IconButton(
        icon: Icon(
          Icons.add,
          size: 20,
        ),
        onPressed: () {
          _navigateToUserEdit(null);
        },
      ));
    }
    return list;
  }

  List<FocusedMenuItem> _getMenuItems(User user) {
    assert(user != null);
    List<FocusedMenuItem> list = [];
    list.add(FocusedMenuItem(
        title: Text('Send Message'),
        trailingIcon: Icon(
          Icons.send,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          _navigateToMessaging(user);
        }));

    if (widget.user.userType == ORG_ADMINISTRATOR) {
      list.add(FocusedMenuItem(
          title: Text('Edit User'),
          trailingIcon: Icon(
            Icons.create,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            _navigateToUserEdit(user);
          }));
      list.add(FocusedMenuItem(
          title: Text('View Report'),
          trailingIcon: Icon(
            Icons.report,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            _navigateToUserReport(user);
          }));
    }
    return list;
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
              key: _key,
              appBar: AppBar(
                title: Text(
                  'Organization Users',
                  style: Styles.whiteTiny,
                ),
                actions: getIconButtons(),
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
                            Text(
                              'Admins & Field Monitors',
                              style: Styles.blackTiny,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '${_users.length}',
                              style: Styles.whiteBoldSmall,
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
                  preferredSize: Size.fromHeight(100),
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
                          var mType = 'Field Monitor';
                          switch (user.userType) {
                            case ORG_ADMINISTRATOR:
                              mType = 'Team Administrator';
                              break;
                            case ORG_EXECUTIVE:
                              mType = 'Executive';
                              break;
                            case FIELD_MONITOR:
                              mType = 'Field Monitor';
                              break;
                          }
                          return FocusedMenuHolder(
                            menuItems: _getMenuItems(user),
                            animateMenuItems: true,
                            onPressed: () {
                              pp('.... 💛️ 💛️ 💛️ not sure what I pressed ...');
                            },
                            child: Card(
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
                                      children: [
                                        SizedBox(
                                          width: 72,
                                        ),
                                        Text(
                                          mType,
                                          style: Styles.greyLabelTiny,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    )
                                  ],
                                ),
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

  void _navigateToUserEdit(User user) async {
    var list = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: UserEditMain(user)));
    pp('UserListMobile: 💛️ 💛️ Back from user edit, check if we need to refresh? list: ${list.length}');

    if (list != null) {
      if (mounted) {
        _users = list;
        _users.sort((a, b) => (a.name.compareTo(b.name)));
        setState(() {});
      }
    }
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

  void _navigateToMessaging(User user) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomLeft,
            duration: Duration(seconds: 1),
            child: MessageMain(
              user: user,
            )));
  }
}
