import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';

import '../../functions.dart';
import '../../snack.dart';

class MonitorMessage extends StatefulWidget {
  final Project project;
  final User user;

  MonitorMessage({
    required this.project,
    required this.user,
  });

  @override
  _MonitorMessageState createState() => _MonitorMessageState();
}

class _MonitorMessageState extends State<MonitorMessage> {
  String frequency = MONITOR_TWICE_A_DAY;
  bool isBusy = false;
  var _key = GlobalKey<ScaffoldState>();
  void _onRadioButtonSelected(String selected) {
    pp('MessageMobile :  🥦 🥦 🥦 _onRadioButtonSelected: 🍊 $selected 🍊');
    setState(() {
      frequency = selected;
    });
  }

  void _sendMessage() async {
    if (frequency == null) {
      // AppSnackbar.showErrorSnackbar(
      //     scaffoldKey: widget.key, message: 'Please select frequency');
      return;
    }

    setState(() {
      isBusy = true;
    });
    var admin = await Prefs.getUser();
    if (admin != null && admin.userId != widget.user.userId) {
      var msg = OrgMessage(
          name: widget.user.name,
          adminId: admin.userId,
          adminName: admin.name,
          projectName: widget.project.name,
          frequency: frequency,
          message: 'Please collect info',
          userId: widget.user.userId,
          created: DateTime.now().toUtc().toIso8601String(),
          projectId: widget.project.projectId,
          organizationId: widget.project.organizationId);
      try {
        var res = await DataAPI.sendMessage(msg);
        pp('MessageMobile:  🏓  🏓  🏓 Response from server:  🏓 ${res.toJson()}  🏓');
      } catch (e) {
        // AppSnackbar.showErrorSnackbar(
        //     scaffoldKey: widget.key, message: 'Message Send failed : $e');
      }
      setState(() {
        isBusy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.app_registration,
            color: Theme.of(context).primaryColor,
          ),
          title: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            width: widget.project == null ? 0.0 : 300.0,
            child: Text(
              '${widget.project == null ? '' : widget.project.name}',
              style: Styles.blackBoldSmall,
            ),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        RadioButtonGroup(
          labelStyle: Styles.blackSmall,
          picked: frequency,
          labels: [
            MONITOR_ONCE_A_DAY,
            MONITOR_TWICE_A_DAY,
            // MONITOR_THREE_A_DAY,
            MONITOR_ONCE_A_WEEK
          ],
          onSelected: _onRadioButtonSelected,
        ),
        SizedBox(
          height: 4,
        ),
        isBusy
            ? Container(
                height: 24,
                width: 24,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    backgroundColor: Colors.pink[200],
                  ),
                ),
              )
            : widget.project == null
                ? Container()
                : RaisedButton(
                    elevation: 4,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Send Message',
                      style: Styles.whiteSmall,
                    ),
                    onPressed: _sendMessage),
        SizedBox(
          height: 12,
        )
      ],
    );
  }
}
