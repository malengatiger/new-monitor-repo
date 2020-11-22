import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/data/position.dart' as mon;
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/location/loc_bloc.dart';
import 'package:monitorlibrary/snack.dart';

import '../../functions.dart';

class ProjectLocationMobile extends StatefulWidget {
  final Project project;

  ProjectLocationMobile(this.project);

  @override
  _ProjectLocationMobileState createState() => _ProjectLocationMobileState();
}

class _ProjectLocationMobileState extends State<ProjectLocationMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var isBusy = false;
  ProjectPosition _projectPosition;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _key = GlobalKey<ScaffoldState>();
  void _submit() async {
    await _getLocation();

    if (_position == null) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key,
          message: 'Current Location not available',
          actionLabel: '');
      return;
    }
    setState(() {
      isBusy = true;
    });
    try {
      pp('🏀 🏀 🏀 submitting current position ..........');
      var loc = ProjectPosition(
          projectName: widget.project.name,
          caption: 'tbd',
          created: DateTime.now().toIso8601String(),
          position: mon.Position(
              type: 'Point',
              coordinates: [_position.longitude, _position.latitude]),
          projectId: widget.project.projectId);
      var m = await DataAPI.addProjectPosition(position: loc);
      pp('🎽 🎽 🎽 _submit: new projectPosition added .........  🍅 ${m.toJson()} 🍅');
      setState(() {
        isBusy = false;
      });
      Navigator.pop(context);
    } catch (e) {
      AppSnackbar.showErrorSnackbar(scaffoldKey: _key, message: 'Failed: $e');
    }
  }

  Position _position;
  Future _getLocation() async {
    setState(() {
      isBusy = true;
    });
    _position = await locationBloc.getLocation();
    setState(() {
      isBusy = false;
    });
    pp('🎽 🎽 🎽 _submit: current location found: .........  🍅 ${_position.toJson()} 🍅');
    return _position;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            'Project Locations',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    '${widget.project.name}',
                    style: Styles.blackBoldMedium,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Add a Project Location at this location that you are at. This location will be enabled for monitoring',
                    style: Styles.whiteSmall,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.brown[100],
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 2,
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                _position == null
                    ? Container()
                    : Container(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Current Location',
                                style: Styles.greyLabelMedium,
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              Row(
                                children: [
                                  Text('Latitude'),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    '${_position.latitude}',
                                    style: Styles.blackBoldMedium,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Text('Longitude'),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    '${_position.longitude}',
                                    style: Styles.blackBoldMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                SizedBox(
                  height: 48,
                ),
                isBusy
                    ? Container(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          backgroundColor: Colors.black,
                        ),
                      )
                    : RaisedButton(
                        onPressed: _submit,
                        color: Theme.of(context).primaryColor,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 12, bottom: 12),
                          child: Text(
                            'Add Project Location',
                            style: Styles.whiteSmall,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
