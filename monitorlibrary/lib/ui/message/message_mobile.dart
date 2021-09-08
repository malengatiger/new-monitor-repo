import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/ui/message/generic_message.dart';

import '../../functions.dart';

class MessageMobile extends StatefulWidget {
  final User? user;

  const MessageMobile({Key? key,  this.user}) : super(key: key);
  @override
  _MessageMobileState createState() => _MessageMobileState();
}

class _MessageMobileState extends State<MessageMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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
    if (widget.user!.userType == FIELD_MONITOR) {
      setState(() {
        _genericMessage = true;
      });
      return;
    }
    setState(() {
      isBusy = true;
    });
    _projects = await monitorBloc.getOrganizationProjects(
        organizationId: widget.user!.organizationId!, forceRefresh: force);
    setState(() {
      isBusy = false;
    });
  }

  Project? _selectedProject;
  bool _genericMessage = false;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        '${_genericMessage ? 'Generic Message' : 'Project Message'}'),
                    SizedBox(
                      width: 20,
                    ),
                    Switch(value: _genericMessage, onChanged: _onSwitchChanged),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Text(
                  '${widget.user!.name}',
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Container(
                    child: Card(
                        elevation: 8,
                        child: SingleChildScrollView(
                            child: GenericMessage(
                                project: _selectedProject == null? null: _selectedProject!, user: widget.user!))),
                  ),
                ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
            preferredSize: Size.fromHeight(_genericMessage ? 320 : 360)),
      ),
      backgroundColor: Colors.brown[100],
      body: widget.user!.userType == ORG_ADMINISTRATOR
          ? Stack(
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
            )
          : Stack(
              children: [Center(child: Text('Field Monitor Messaging'))],
            ),
    ));
  }

  void _onSwitchChanged(bool value) {
    pp('MessageMobile: 💙 💙 💙 _onSwitchChanged  💙 $value');
    setState(() {
      _genericMessage = value;
    });
  }
}
