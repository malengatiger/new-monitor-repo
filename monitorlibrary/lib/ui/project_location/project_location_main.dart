import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/ui/project_location/project_location_desktop.dart';
import 'package:monitorlibrary/ui/project_location/project_location_mobile.dart';
import 'package:monitorlibrary/ui/project_location/project_location_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProjectLocationMain extends StatefulWidget {
  final Project project;
  ProjectLocationMain(this.project);

  @override
  _ProjectLocationMainState createState() => _ProjectLocationMainState();
}

class _ProjectLocationMainState extends State<ProjectLocationMain> {
  @override
  void initState() {
    super.initState();
   // _getProjectLocations();
  }

  var isBusy = false;

  void _getProjectLocations() async {
    setState(() {
      isBusy = true;
    });
    await monitorBloc.getProjectPositions(projectId: widget.project.projectId);
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
                title: Text('Loading Project positions ...'),
              ),
              backgroundColor: Colors.brown[100],
              body: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          )
        : ScreenTypeLayout(
            mobile: ProjectLocationMobile(widget.project),
            tablet: ProjectLocationTablet(widget.project),
            desktop: ProjectLocationDesktop(widget.project),
          );
  }
}
