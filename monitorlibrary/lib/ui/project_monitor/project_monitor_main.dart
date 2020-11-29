import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/ui/project_monitor/project_monitor_desktop.dart';
import 'package:monitorlibrary/ui/project_monitor/project_monitor_mobile.dart';
import 'package:monitorlibrary/ui/project_monitor/project_monitor_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProjectMonitorMain extends StatefulWidget {
  final Project project;

  const ProjectMonitorMain(this.project);
  @override
  _ProjectMonitorMainState createState() => _ProjectMonitorMainState();
}

class _ProjectMonitorMainState extends State<ProjectMonitorMain>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isBusy = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                child: CircularProgressIndicator(
                  strokeWidth: 16,
                  backgroundColor: Colors.pink,
                ),
              ),
            ),
          )
        : ScreenTypeLayout(
            mobile: ProjectMonitorMobile(widget.project),
            tablet: ProjectMonitorTablet(widget.project),
            desktop: ProjectMonitorDesktop(widget.project),
          );
  }
}

abstract class ProjectDetailBase {
  startProjectMonitoring();
  listMonitorReports();
  listNearestCities();
  updateProject();
}
