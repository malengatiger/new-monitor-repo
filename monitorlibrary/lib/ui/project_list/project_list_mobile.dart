import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/bloc/theme_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/data/user.dart' as mon;
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/maps/project_map_main.dart';
import 'package:monitorlibrary/ui/mapx.dart';
import 'package:monitorlibrary/ui/media/media_list_main.dart';
import 'package:monitorlibrary/ui/project_edit/project_edit_main.dart';
import 'package:monitorlibrary/ui/project_monitor/project_monitor_main.dart';
import 'package:page_transition/page_transition.dart';

class ProjectListMobile extends StatefulWidget {
  final mon.User user;

  ProjectListMobile(this.user);

  @override
  _ProjectListMobileState createState() => _ProjectListMobileState();
}

class _ProjectListMobileState extends State<ProjectListMobile>
    with SingleTickerProviderStateMixin
    implements ProjectActionsListener {
  AnimationController _controller;
  var projects = List<Project>();
  mon.User user;
  bool isBusy = false;
  bool isProjectsByLocation = false;
  var userTypeLabel = 'Unknown User Type';

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getUser();
  }

  void _getUser() async {
    setState(() {
      isBusy = true;
    });
    user = await Prefs.getUser();
    setState(() {
      switch (user.userType) {
        case FIELD_MONITOR:
          userTypeLabel = 'Field Monitor';
          break;
        case ORG_ADMINISTRATOR:
          userTypeLabel = 'Administrator';
          break;
      }
    });

    if (user != null) {
      await refreshProjects();
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

  Future refreshProjects() async {
    setState(() {
      isBusy = true;
    });
    if (isProjectsByLocation) {
      projects = await monitorBloc.getProjectsWithinRadius(
          radiusInKM: 3.0, checkUserOrg: true);
      pp('🦠 🦠 🦠 🦠 🦠  ProjectList: Projects within given radius ; '
          'found: 💜 ${projects.length} projects');
    } else {
      projects = await monitorBloc.getOrganizationProjects(
          organizationId: user.organizationId);
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<Project>>(
          stream: monitorBloc.projectStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              projects = snapshot.data;
            }
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Projects',
                    style: Styles.whiteSmall,
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        themeBloc.changeToRandomTheme();
                      },
                    ),
                    IconButton(
                      icon: isProjectsByLocation
                          ? Icon(Icons.list_alt)
                          : Icon(Icons.location_on_outlined),
                      onPressed: () {
                        isProjectsByLocation = !isProjectsByLocation;
                        refreshProjects();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.map_outlined),
                      onPressed: () {
                        _navigateToOrgMap();
                      },
                    ),
                    widget.user.userType == FIELD_MONITOR
                        ? Container()
                        : IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _navigateToDetail(null);
                            },
                          ),
                  ],
                  bottom: PreferredSize(
                    child: Column(
                      children: [
                        Text(
                          user == null ? 'Unknown User' : user.name,
                          style: Styles.whiteBoldMedium,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '$userTypeLabel',
                          style: Styles.blackSmall,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          user == null ? '' : '${user.organizationName}',
                          style: Styles.whiteSmall,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                    preferredSize: Size.fromHeight(120),
                  ),
                ),
                backgroundColor: Colors.brown[100],
                body: isBusy
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                                backgroundColor: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(isProjectsByLocation
                                ? 'Finding Projects within 3 KM'
                                : 'Finding Organization Projects'),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: projects.isEmpty
                            ? Center(
                                child: Text(
                                  'Projects Not Found',
                                  style: Styles.blackBoldMedium,
                                ),
                              )
                            : Stack(
                                children: [
                                  ListView.builder(
                                    itemCount: projects.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var proj = projects.elementAt(index);

                                      return GestureDetector(
                                        onTap: () {
                                          pp('🔆 🔆 🔆 💜 💜 Project tapped: ${projects.elementAt(index).name} '
                                              'at index: $index ');
                                          _showFuckingActions(
                                              projects.elementAt(index));
                                        },
                                        child: Card(
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 24,
                                                ),
                                                Row(
                                                  children: [
                                                    Opacity(
                                                      opacity: 0.5,
                                                      child: Icon(
                                                        Icons.settings,
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      proj.name,
                                                      style:
                                                          Styles.blackBoldSmall,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  openProjectActions
                                      ? Positioned(
                                          left: 20,
                                          bottom: 20,
                                          child: ProjectActions(
                                            context: context,
                                            project: _currentProject,
                                            user: user,
                                            listener: this,
                                          ),
                                        )
                                      : Container(),
                                ],
                              )));
          }),
    );
  }

  Project _currentProject;
  bool openProjectActions = false;
  void _navigateToDetail(Project p) {
    if (user.userType == FIELD_MONITOR) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(milliseconds: 1500),
              child: ProjectMonitorMain(p)));
    }
    if (user.userType == ORG_ADMINISTRATOR) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(milliseconds: 1500),
              child: ProjectEditMain(p)));
    }
  }

  void _navigateToOrgMap() {
    pp('_navigateToOrgMap: ');
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 1500),
            child: MonitorMap()));
  }

  @override
  onActionsClose() {
    setState(() {
      _currentProject = null;
      openProjectActions = false;
    });
  }

  void _showFuckingActions(Project project) {
    pp(' 🍎  🍎 _showFuckingActions: _currentProject is  🍎 ${project.name}');
    _currentProject = project;
    setState(() {
      openProjectActions = true;
    });
  }
}

class ProjectActions extends StatelessWidget {
  final Project project;
  final BuildContext context;
  final User user;
  final ProjectActionsListener listener;

  ProjectActions(
      {@required this.context,
      @required this.project,
      @required this.user,
      @required this.listener});

  void _navigateToDetail() {
    listener.onActionsClose();
    if (user.userType == FIELD_MONITOR) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(milliseconds: 1500),
              child: ProjectMonitorMain(project)));
    }
    if (user.userType == ORG_ADMINISTRATOR) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(milliseconds: 1500),
              child: ProjectEditMain(project)));
    }
  }

  void _navigateToProjectMap() {
    pp('_navigateToProjectMap :  ${project.name}');
    listener.onActionsClose();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 1500),
            child: ProjectMapMain(project)));
  }

  void _navigateToMediaList() {
    pp('💜 💜 💜 Navigating to the MediaList ... 💜 💜 💜');
    listener.onActionsClose();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 1500),
            child: MediaListMain(project)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      color: Colors.brown[50],
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    listener.onActionsClose();
                  },
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
            Text(
              '${project.name}',
              style: Styles.blackBoldSmall,
            ),
            SizedBox(
              height: 16,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _navigateToDetail();
                  },
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToDetail();
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Edit or Monitor'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToProjectMap();
                  },
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          _navigateToProjectMap();
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Project on Map'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToMediaList();
                  },
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          _navigateToMediaList();
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Photos & Videos'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

abstract class ProjectActionsListener {
  onActionsClose();
}
