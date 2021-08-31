import 'package:flutter/material.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/maps/project_map_desktop.dart';
import 'package:monitorlibrary/ui/maps/project_map_mobile.dart';
import 'package:monitorlibrary/ui/maps/project_map_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../snack.dart';

class ProjectMapMain extends StatefulWidget {
  final Project project;
  final Photo? photo;

  ProjectMapMain({required this.project, this.photo});

  @override
  _ProjectMapMainState createState() => _ProjectMapMainState();
}

class _ProjectMapMainState extends State<ProjectMapMain> {
  var isBusy = false;
  var _positions = <ProjectPosition>[];
  var _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _getProjectPositions();
  }

  void _getProjectPositions() async {
    setState(() {
      isBusy = true;
    });
    try {
      _positions = await monitorBloc.getProjectPositions(
          projectId: widget.project.projectId!, forceRefresh: false);
    } catch (e) {
      print(e);
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Data refresh failed: $e');
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? SafeArea(
            child: Scaffold(
              key: _key,
              appBar: AppBar(
                title: Text(
                  'Loading Project locations',
                  style: Styles.whiteTiny,
                ),
              ),
              body: Center(
                child: Container(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 12,
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
              photo: widget.photo,
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
