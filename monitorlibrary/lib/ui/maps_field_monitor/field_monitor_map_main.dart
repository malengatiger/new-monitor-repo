import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../snack.dart';
import 'field_monitor_map_desktop.dart';
import 'field_monitor_map_mobile.dart';
import 'field_monitor_map_tablet.dart';

class FieldMonitorMapMain extends StatefulWidget {
  final User user;

  FieldMonitorMapMain(this.user);

  @override
  _FieldMonitorMapMainState createState() => _FieldMonitorMapMainState();
}

class _FieldMonitorMapMainState extends State<FieldMonitorMapMain> {
  var isBusy = false;
  var _positions = [];
  var _key = GlobalKey<ScaffoldState>();
  User? _updatedUser;
  @override
  void initState() {
    super.initState();
  }

  void _updateUserPosition({required double latitude, required double longitude}) async {
    setState(() {
      isBusy = true;
    });
    try {
      widget.user.position =
          Position(type: 'Point', coordinates: [longitude, latitude]);
      _updatedUser = await DataAPI.updateUser(widget.user);
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
            mobile: FieldMonitorMapMobile(
              widget.user,
            ),
            tablet: FieldMonitorMapTablet(widget.user),
            desktop: FieldMonitorMapDesktop(widget.user),
          );
  }
}
