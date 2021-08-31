import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/media/list/media_list_desktop.dart';
import 'package:monitorlibrary/ui/media/list/media_list_mobile.dart';
import 'package:monitorlibrary/ui/media/list/media_list_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MediaListMain extends StatefulWidget {
  final Project project;

  MediaListMain(this.project);

  @override
  _MediaListMainState createState() => _MediaListMainState();
}

class _MediaListMainState extends State<MediaListMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var isBusy = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getMedia();
  }

  void _getMedia() async {
    setState(() {
      isBusy = true;
    });
    if (widget.project != null) {
      pp('MediaListMain: 💜 💜 💜 getting media for PROJECT: ${widget.project.name}');
      await monitorBloc.refreshProjectData(
          projectId: widget.project.projectId!, forceRefresh: false);
    } else {
      var user = await Prefs.getUser();
      pp('MediaListMain: 💜 💜 💜 getting media for ORGANIZATION: ${user!.organizationName!}');
      await monitorBloc.refreshOrgDashboardData(forceRefresh: false);
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

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Loading project media ...',
                  style: Styles.whiteSmall,
                ),
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
            mobile: MediaListMobile(widget.project),
            tablet: MediaListTablet(widget.project),
            desktop: MediaListDesktop(widget.project),
          );
  }
}
