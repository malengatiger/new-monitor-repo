import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/snack.dart';

import '../../functions.dart';

class MessageMobile extends StatefulWidget {
  final User user;

  const MessageMobile({Key key, this.user}) : super(key: key);
  @override
  _MessageMobileState createState() => _MessageMobileState();
}

class _MessageMobileState extends State<MessageMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var _key = GlobalKey<ScaffoldState>();
  List<Project> _projects = [];

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getProjects(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getProjects(bool force) async {
    setState(() {
      isBusy = true;
    });
    _projects = await monitorBloc.getOrganizationProjects(
        organizationId: widget.user.organizationId, forceRefresh: force);
    setState(() {
      isBusy = false;
    });
  }

  Project _selectedProject;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Digital Monitor Messaging',
          style: Styles.whiteSmall,
        ),
        bottom: PreferredSize(
            child: Column(
              children: [
                Text(
                  '${widget.user.name}',
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                  child: Container(
                    child: Card(
                        elevation: 4,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.app_registration,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(
                                  '${_selectedProject == null ? '' : _selectedProject.name}',
                                  style: Styles.blackBoldSmall,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              RadioButtonGroup(
                                labelStyle: Styles.blackSmall,
                                picked: frequency,
                                labels: [
                                  MONITOR_ONCE_A_DAY,
                                  MONITOR_TWICE_A_DAY,
                                  // MONITOR_THREE_A_DAY,
                                  MONITOR_ONCE_A_WEEK
                                ],
                                onSelected: _onRadioButtonSelected,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              isBusy
                                  ? Container(
                                      height: 24,
                                      width: 24,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 4,
                                          backgroundColor: Colors.pink[200],
                                        ),
                                      ),
                                    )
                                  : _selectedProject == null
                                      ? Container()
                                      : RaisedButton(
                                          elevation: 4,
                                          color: Theme.of(context).primaryColor,
                                          child: Text(
                                            'Send Message',
                                            style: Styles.whiteSmall,
                                          ),
                                          onPressed: _sendMessage),
                              SizedBox(
                                height: 12,
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
            preferredSize: Size.fromHeight(360)),
      ),
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
                itemCount: _projects.length,
                itemBuilder: (context, index) {
                  var p = _projects.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedProject = p;
                      });
                    },
                    child: Card(
                      child: ListTile(
                        title: Text('${p.name}'),
                        leading: Icon(
                          Icons.app_registration,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    ));
  }

  String frequency = MONITOR_TWICE_A_DAY;
  bool isBusy = false;
  void _onRadioButtonSelected(String selected) {
    pp('MessageMobile :  🥦 🥦 🥦 _onRadioButtonSelected: 🍊 $selected 🍊');
    setState(() {
      frequency = selected;
    });
  }

  void _sendMessage() async {
    if (frequency == null) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Please select frequency');
      return;
    }
    if (_selectedProject == null) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Please select Project');
      return;
    }
    setState(() {
      isBusy = true;
    });
    var admin = await Prefs.getUser();
    if (admin != null && admin.userId != widget.user.userId) {
      var msg = OrgMessage(
          name: widget.user.name,
          adminId: admin.userId,
          adminName: admin.name,
          projectName: _selectedProject.name,
          frequency: frequency,
          message: 'Please collect info',
          userId: widget.user.userId,
          created: DateTime.now().toUtc().toIso8601String(),
          projectId: _selectedProject.projectId,
          organizationId: _selectedProject.organizationId);
      try {
        var res = await DataAPI.sendMessage(msg);
        pp('MessageMobile:  🏓  🏓  🏓 Response from server:  🏓 ${res.toJson()}  🏓');
      } catch (e) {
        AppSnackbar.showErrorSnackbar(
            scaffoldKey: _key, message: 'Message Send failed : $e');
      }
      setState(() {
        isBusy = false;
      });
    }
  }
}
