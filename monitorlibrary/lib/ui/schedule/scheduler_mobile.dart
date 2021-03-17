import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/field_monitor_schedule.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

class SchedulerMobile extends StatefulWidget {
  final User user;

  SchedulerMobile(this.user);

  @override
  _SchedulerMobileState createState() => _SchedulerMobileState();
}

class _SchedulerMobileState extends State<SchedulerMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool busy = false;
  User _adminUser;
  List<Project> _projects = [];
  var _key = GlobalKey<ScaffoldState>();
  static const mm = 'SchedulerMobile: 🍏 🍏 🍏 🍏 ';
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getData(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getData(bool refresh) async {
    pp('$mm getting list of projects ...');
    setState(() {
      busy = true;
    });
    try {
      _adminUser = await Prefs.getUser();
      _projects = await monitorBloc.getOrganizationProjects(
          organizationId: widget.user.organizationId, forceRefresh: refresh);
      pp('$mm ${_projects.length} projects ...');
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Project list failed: $e');
    }
    setState(() {
      busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text('FieldMonitor Schedule', style: Styles.whiteSmall),
              bottom: PreferredSize(
                  child: Column(
                    children: [
                      Text(
                        widget.user.name,
                        style: Styles.blackBoldMedium,
                      ),
                      Text(
                        'FieldMonitor',
                        style: Styles.blackSmall,
                      ),
                      SizedBox(
                        height: 48,
                      ),
                    ],
                  ),
                  preferredSize: Size.fromHeight(100)),
            ),
            backgroundColor: Colors.brown[100],
            body: busy
                ? Center(
                    child: Container(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                        backgroundColor: Colors.amber,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          child: ListView.builder(
                              itemCount: _projects.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _navigateToFrequencyEditor(
                                        _projects.elementAt(index));
                                  },
                                  child: Card(
                                    elevation: 2,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.home,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      title: Text(
                                        _projects.elementAt(index).name,
                                        style: Styles.blackBoldSmall,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  )));
  }

  void _navigateToFrequencyEditor(Project project) async {
    pp('$mm _navigateToFrequencyEditor: project.name: ${project.name}');
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomRight,
            duration: Duration(seconds: 1),
            child: FrequencyEditor(
              project: project,
              adminUser: _adminUser,
              fieldUser: widget.user,
            )));
    if (result is bool) {
      pp('$mm Yebo Yes!!! schedule has been written to database 🍎');
      if (mounted) {
        AppSnackbar.showSnackbar(
            scaffoldKey: _key,
            message: 'Scheduling for FieldMonitor saved',
            textColor: Colors.teal,
            backgroundColor: Colors.black);
      }
    }
  }
}

class FrequencyEditor extends StatefulWidget {
  final Project project;
  final User adminUser, fieldUser;

  const FrequencyEditor({Key key, this.project, this.adminUser, this.fieldUser})
      : super(key: key);

  @override
  _FrequencyEditorState createState() => _FrequencyEditorState();
}

class _FrequencyEditorState extends State<FrequencyEditor> {
  var _perDayController = TextEditingController(text: "3");
  var _perWeekController = TextEditingController(text: "0");
  var _perMonthController = TextEditingController(text: "0");
  var _width = 300.0;
  var _height = 480.0;
  bool busy = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Project Monitoring Frequency',
          style: Styles.whiteSmall,
        ),
        bottom: PreferredSize(
            child: Column(
              children: [
                Text(
                  widget.fieldUser.name,
                  style: Styles.blackBoldMedium,
                ),
                Text(
                  'FieldMonitor',
                  style: Styles.blackSmall,
                ),
                SizedBox(
                  height: 48,
                ),
              ],
            ),
            preferredSize: Size.fromHeight(100)),
      ),
      backgroundColor: Colors.brown[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: busy
                ? Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                        backgroundColor: Colors.amber,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${widget.project.name}',
                          style: Styles.blackBoldMedium,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Project to be Monitored',
                          style: Styles.blackSmall,
                        ),
                        SizedBox(
                          height: 28,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0, right: 28),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _perDayController,
                              keyboardType: TextInputType.number,
                              style: Styles.blackBoldMedium,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.alarm,
                                  color: Colors.blue,
                                ),
                                hintText: 'Enter frequency per day',
                                labelText: 'Frequency Per Day',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0, right: 28),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _perWeekController,
                              keyboardType: TextInputType.number,
                              style: Styles.blackBoldMedium,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.alarm,
                                  color: Colors.blue,
                                ),
                                hintText: 'Enter frequency per week',
                                labelText: 'Frequency Per Week',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0, right: 28),
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _perMonthController,
                              keyboardType: TextInputType.number,
                              style: Styles.blackBoldMedium,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.alarm,
                                  color: Colors.blue,
                                ),
                                hintText: 'Enter frequency per month',
                                labelText: 'Frequency Per Month',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _doSubmit(
                                  perDay: _perDayController.text,
                                  perWeek: _perWeekController.text,
                                  perMonth: _perMonthController.text);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.pink,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Submit Schedule'),
                            )),
                        SizedBox(
                          height: 48,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    ));
  }

  void _doSubmit({String perDay, String perWeek, String perMonth}) async {
    pp('SchedulerMobile: ............. '
        '🍏 🍏 🍏 🍏 _doSubmit: ...perDay: $perDay perWeek: $perWeek perMonth: $perMonth');
    Uuid uuid = Uuid();
    String id = uuid.v4();
    setState(() {
      busy = true;
    });
    try {
      int _perDay = int.parse(perDay);
      int _perWeek = int.parse(perWeek);
      int _perMonth = int.parse(perMonth);

      var sc = FieldMonitorSchedule(
          fieldMonitorId: widget.fieldUser.userId,
          adminId: widget.adminUser.userId,
          projectId: widget.project.projectId,
          date: DateTime.now().toIso8601String(),
          organizationId: widget.project.organizationId,
          perDay: _perDay,
          perWeek: _perWeek,
          perMonth: _perMonth,
          organizationName: widget.project.organizationName,
          projectName: widget.project.name,
          fieldMonitorScheduleId: id);

      var result = await DataAPI.addFieldMonitorSchedule(sc);
      pp('SchedulerMobile: 🍏 🍏 🍏 🍏 RESULT: ${result.toJson()}');
      setState(() {
        busy = false;
      });
      Navigator.pop(context, true);
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: widget.key, message: 'Scheduling failed: $e');
    }
    setState(() {
      busy = false;
    });
  }
}
