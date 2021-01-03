import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/fcm_bloc.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/data/user.dart' as mon;
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/maps/project_map_main.dart';
import 'package:monitorlibrary/ui/media/media_list_main.dart';
import 'package:monitorlibrary/ui/project_edit/project_edit_main.dart';
import 'package:monitorlibrary/ui/project_location/project_location_main.dart';
import 'package:monitorlibrary/ui/project_monitor/project_monitor_main.dart';
import 'package:page_transition/page_transition.dart';

import '../../snack.dart';

class ProjectListMobile extends StatefulWidget {
  final mon.User user;

  ProjectListMobile(this.user);

  @override
  _ProjectListMobileState createState() => _ProjectListMobileState();
}

class _ProjectListMobileState extends State<ProjectListMobile>
    with SingleTickerProviderStateMixin {
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
    user = widget.user;
    if (user == null) {
      _getUser();
    } else {
      _setUserType();
    }
    _listen();
    refreshProjects(false);
  }

  void _listen() {
    fcmBloc.projectStream.listen((Project project) {
      if (mounted) {
        AppSnackbar.showSnackbar(
            scaffoldKey: _key,
            message: 'Project added: ${project.name}',
            textColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor);
      }
    });
  }

  void _getUser() async {
    setState(() {
      isBusy = true;
    });
    user = await Prefs.getUser();
    _setUserType();
    setState(() {
      isBusy = false;
    });
  }

  void _setUserType() {
    setState(() {
      switch (user.userType) {
        case FIELD_MONITOR:
          userTypeLabel = 'Field Monitor';
          break;
        case ORG_ADMINISTRATOR:
          userTypeLabel = 'Team Administrator';
          break;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future refreshProjects(bool forceRefresh) async {
    if (mounted) {
      setState(() {
        isBusy = true;
      });
    }
    try {
      if (isProjectsByLocation) {
        projects = await monitorBloc.getProjectsWithinRadius(
            radiusInKM: 3.0, checkUserOrg: true);
        pp('🦠 🦠 🦠 🦠 🦠  ProjectList: Projects within given radius ; '
            'found: 💜 ${projects.length} projects');
      } else {
        projects = await monitorBloc.getOrganizationProjects(
            organizationId: user.organizationId, forceRefresh: forceRefresh);
        pp('🦠 🦠 🦠 🦠 🦠  ProjectList: Organization Projects '
            'found: 💜 ${projects.length} projects');
      }
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Data refresh failed');
    }
    if (mounted) {
      setState(() {
        isBusy = false;
      });
    }
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

  void _navigateToProjectLocation(Project p) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 1500),
            child: ProjectLocationMain(p)));
  }

  void _navigateToMedia(Project p) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 1500),
            child: MediaListMain(p)));
  }

  void _navigateToOrgMap(Project p) {
    pp('_navigateToOrgMap: ');
    if (p != null) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(milliseconds: 1500),
              child: ProjectMapMain(
                p,
              )));
    }
  }

  List<FocusedMenuItem> getPopUpMenuItems(Project p) {
    List<FocusedMenuItem> menuItems = [];
    menuItems.add(
      FocusedMenuItem(
          title: Text('Project Map'),
          trailingIcon: Icon(
            Icons.map,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            _navigateToOrgMap(p);
          }),
    );
    menuItems.add(
      FocusedMenuItem(
          title: Text('Photos & Videos'),
          trailingIcon: Icon(
            Icons.camera,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            _navigateToMedia(p);
          }),
    );
    if (user.userType == ORG_ADMINISTRATOR) {
      menuItems.add(FocusedMenuItem(
          title: Text('Edit Project'),
          trailingIcon: Icon(
            Icons.create,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            if (user.userType == ORG_ADMINISTRATOR) {
              _navigateToDetail(p);
            }
          }));
      menuItems.add(FocusedMenuItem(
          title: Text('Add Project Location'),
          trailingIcon: Icon(
            Icons.location_pin,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            if (user.userType == ORG_ADMINISTRATOR) {
              _navigateToProjectLocation(p);
            }
          }));
    }
    return menuItems;
  }

  var _key = GlobalKey<ScaffoldState>();
  List<IconButton> _getActions() {
    List<IconButton> list = [];
    // list.add(IconButton(
    //   icon: Icon(Icons.settings),
    //   onPressed: () {
    //     themeBloc.changeToRandomTheme();
    //   },
    // ));
    list.add(IconButton(
      icon: isProjectsByLocation
          ? Icon(Icons.list_alt)
          : Icon(Icons.location_on_outlined),
      onPressed: () {
        isProjectsByLocation = !isProjectsByLocation;
        refreshProjects(true);
      },
    ));
    if (projects.isNotEmpty) {
      list.add(
        IconButton(
          icon: Icon(Icons.map_outlined),
          onPressed: () {
            _navigateToOrgMap(null);
          },
        ),
      );
    }
    if (user.userType == ORG_ADMINISTRATOR) {
      list.add(
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _navigateToDetail(null);
          },
        ),
      );
      list.add(
        IconButton(
          icon: Icon(Icons.location_pin),
          onPressed: () {
            _navigateToDetail(null);
          },
        ),
      );
    }
    return list;
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
                key: _key,
                appBar: AppBar(
                  title: Text(
                    'Projects',
                    style: Styles.whiteTiny,
                  ),
                  actions: _getActions(),
                  bottom: PreferredSize(
                    child: Column(
                      children: [
                        Text(
                          user == null ? 'Unknown User' : user.organizationName,
                          style: Styles.blackBoldSmall,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                          user == null ? '' : '${user.name}',
                          style: Styles.whiteSmall,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          '$userTypeLabel',
                          style: Styles.blackTiny,
                        ),
                        SizedBox(
                          height: 20,
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
                              width: 48,
                              height: 48,
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
                                      var selectedProject =
                                          projects.elementAt(index);

                                      return FocusedMenuHolder(
                                        menuOffset: 20,
                                        duration: Duration(milliseconds: 300),
                                        menuItems:
                                            getPopUpMenuItems(selectedProject),
                                        animateMenuItems: true,
                                        onPressed: () {
                                          pp('.... 💛️ 💛️ 💛️ not sure what I pressed ...');
                                        },
                                        child: Card(
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  children: [
                                                    Opacity(
                                                      opacity: 0.5,
                                                      child: Icon(
                                                        Icons.settings,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        selectedProject.name,
                                                        style: Styles
                                                            .blackBoldSmall,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )));
          }),
    );
  }
}
