import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/field_monitor_schedule.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';
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
    pp('SchedulerMobile: ............. '
        '🍏 🍏 🍏 🍏 getting list of projects ...');
    setState(() {
      busy = true;
    });
    try {
      _adminUser = await Prefs.getUser();
      _projects = await monitorBloc.getOrganizationProjects(
          organizationId: widget.user.organizationId, forceRefresh: refresh);
      pp('SchedulerMobile: .............  🍏 🍏 🍏 🍏 ${_projects.length} projects ...');
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Project list failed: $e');
    }
    setState(() {
      busy = false;
    });
  }

  Project _project;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text('FieldMonitor Schedule', style: Styles.whiteSmall),
              bottom: PreferredSize(
                  child: Column(), preferredSize: Size.fromHeight(120)),
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
                      _project != null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                child: ListView.builder(
                                    itemCount: _projects.length,
                                    itemBuilder: (context, index) {
                                      // _project = _projects.elementAt(index);
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Card(
                                          elevation: 2,
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.home,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: Text(
                                              _project.name,
                                              style: Styles.blackBoldSmall,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                      _project == null
                          ? Container()
                          : Positioned(
                              left: 20,
                              top: 0,
                              child: FrequencyEditor(
                                project: _project,
                                adminUser: _adminUser,
                                fieldUser: widget.user,
                              )),
                    ],
                  )));
  }

  void doTheRealSubmit() async {}
}

class FrequencyEditor extends StatelessWidget {
  final Project project;
  final User adminUser, fieldUser;

  const FrequencyEditor({Key key, this.project, this.adminUser, this.fieldUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _perDayController = TextEditingController(text: "3");
    var _perWeekController = TextEditingController(text: "0");
    var _perMonthController = TextEditingController(text: "0");
    var _width = 300.0;
    var _height = 480.0;
    return AnimatedContainer(
      curve: Curves.elasticInOut,
      height: _height,
      width: _width,
      color: Colors.teal[100],
      duration: Duration(milliseconds: 1000),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  fieldUser.name,
                  style: Styles.blackBoldMedium,
                ),
                Text(
                  'FieldMonitor',
                  style: Styles.blackSmall,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        project.name,
                        style: Styles.blackBoldSmall,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Monitoring Frequency'),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _perDayController,
                        keyboardType: TextInputType.number,
                        style: Styles.blackBoldMedium,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.alarm,
                            color: Colors.pink,
                          ),
                          hintText: 'Enter frequency per day',
                          labelText: 'Frequency Per Day',
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
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
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _perMonthController,
                        style: Styles.blackBoldMedium,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.alarm,
                            color: Colors.teal,
                          ),
                          hintText: 'Enter frequency per month',
                          labelText: 'Frequency Per Month',
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
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Submit Schedule'),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _doSubmit({String perDay, String perWeek, String perMonth}) async {
    pp('SchedulerMobile: ............. '
        '🍏 🍏 🍏 🍏 _doSubmit: ...perDay: $perDay perWeek: $perWeek perMonth: $perMonth');
    Uuid uuid = Uuid();
    String id = uuid.v4();
    try {
      int _perDay = int.parse(perDay);
      int _perWeek = int.parse(perWeek);
      int _perMonth = int.parse(perMonth);

      var sc = FieldMonitorSchedule(
          fieldMonitorId: fieldUser.userId,
          adminId: adminUser.userId,
          projectId: project.projectId,
          date: DateTime.now().toIso8601String(),
          organizationId: project.projectId,
          perDay: _perDay,
          perWeek: _perWeek,
          perMonth: _perMonth,
          organizationName: project.organizationName,
          projectName: project.name,
          fieldMonitorScheduleId: id);
      var result = await DataAPI.addFieldMonitorSchedule(sc);
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: key, message: 'Scheduling failed: $e');
    }
  }
}
