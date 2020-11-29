import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/user.dart' as mon;
import 'package:monitorlibrary/ui/project_list/project_list_desktop.dart';
import 'package:monitorlibrary/ui/project_list/project_list_mobile.dart';
import 'package:monitorlibrary/ui/project_list/project_list_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../functions.dart';

class ProjectListMain extends StatefulWidget {
  final mon.User user;

  ProjectListMain(this.user);

  @override
  _ProjectListMainState createState() => _ProjectListMainState();
}

class _ProjectListMainState extends State<ProjectListMain>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var isBusy = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _loadProjects();
  }

  void _loadProjects() async {
    setState(() {
      isBusy = true;
    });
    await monitorBloc.getOrganizationProjects(
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
    return isBusy
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Loading projects ...',
                  style: Styles.whiteSmall,
                ),
              ),
              backgroundColor: Colors.brown[100],
              body: Center(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          )
        : ScreenTypeLayout(
            mobile: ProjectListMobile(widget.user),
            tablet: ProjectListTablet(widget.user),
            desktop: ProjectListDesktop(widget.user),
          );
  }
}
