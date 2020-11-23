import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/ui/maps/project_map_desktop.dart';
import 'package:monitorlibrary/ui/maps/project_map_mobile.dart';
import 'package:monitorlibrary/ui/maps/project_map_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProjectMapMain extends StatefulWidget {
  final Project project;

  ProjectMapMain(this.project);

  @override
  _ProjectMapMainState createState() => _ProjectMapMainState();
}

class _ProjectMapMainState extends State<ProjectMapMain> {
  var isBusy = false;
  var _positions = List<ProjectPosition>();
  @override
  void initState() {
    super.initState();
    _getProjectPositions();
  }

  void _getProjectPositions() async {
    setState(() {
      isBusy = true;
    });
    _positions = await monitorBloc.getProjectPositions(
        projectId: widget.project.projectId);
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
                title: Text('Loading Project map locations'),
              ),
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
            mobile: ProjectMapMobile(
              project: widget.project,
              projectPositions: _positions,
            ),
            tablet: ProjectMapTablet(
              project: widget.project,
              projectPositions: _positions,
            ),
            desktop: ProjectMapDesktop(
              project: widget.project,
              projectPositions: _positions,
            ),
          );
  }
}
