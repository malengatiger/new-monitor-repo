import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/local_mongo.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/location/loc_bloc.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:monitorlibrary/ui/media/media_house.dart';
import 'package:monitorlibrary/ui/project_location/project_location_main.dart';
import 'package:page_transition/page_transition.dart';

class ProjectMonitorMobile extends StatefulWidget {
  final Project project;

  ProjectMonitorMobile(this.project);

  @override
  _ProjectMonitorMobileState createState() => _ProjectMonitorMobileState();
}
///Checks whether the device is within monitoring distance for the project
class _ProjectMonitorMobileState extends State<ProjectMonitorMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var isBusy = false;
  var _key = GlobalKey<ScaffoldState>();
  var positions = <ProjectPosition>[];

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getProjectPositions();
  }

  void _getProjectPositions() async {

    setState(() {
      isBusy = true;
    });
    try {
      positions = await monitorBloc.getProjectPositions(
          projectId: widget.project.projectId!, forceRefresh: false);
    } catch (e) {
      print(e);
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Data refresh failed: $e');
    }

    setState(() {
      widget.project.projectPositions = positions;
      isBusy = false;
    });
    _checkProjectDistance();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(widget.project.organizationName!,
              style: Styles.whiteBoldSmall),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _checkProjectDistance,
            ),
            IconButton(
              icon: Icon(Icons.directions),
              onPressed: _navigateToDirections,
            )
          ],
          bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(widget.project.name!, style: Styles.blackBoldSmall),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'The project should be monitored only when the device is within a radius of',
                    style: Styles.whiteSmall,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('${widget.project.monitorMaxDistanceInMetres}',
                      style: Styles.blackBoldMedium),
                  SizedBox(
                    height: 0,
                  ),
                  Text('metres'),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(240),
          ),
        ),
        backgroundColor: Colors.brown[100],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                  ),
                  isWithinDistance
                      ? ElevatedButton(
                          style: ButtonStyle(elevation: MaterialStateProperty.all(8)),
                          onPressed: () async {
                            isWithinDistance = await _checkProjectDistance();
                            if (isWithinDistance) {
                              _startMonitoring();
                            } else {
                              setState(() {});
                              _showError();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Start Monitor',
                              style: Styles.whiteSmall,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 24,
                  ),
                  isBusy
                      ? Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: Colors.yellowAccent,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Checking project location',
                              style: Styles.blackTiny,
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 24,
                  ),
                  isWithinDistance
                      ? Container(
                          child: Text('We are ready to start creating photos and videos for ${widget.project.name}',
                              style: Styles.greyLabelMedium),
                        )
                      : Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Device is too far from ${widget.project.name} for monitoring capabilities. Please move closer!',
                              style: Styles.greyLabelMedium,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<ProjectPosition?> _findNearestProjectPosition() async {
    var bags = <BagX>[];
    var positions = await LocalMongo.getProjectPositions(widget.project.projectId!);
    if (positions.isEmpty) {
      _navigateToProjectLocation();
    } else {
      if (positions.length == 1) {
        return positions.first;
      }
      positions.forEach((pos) async {
        var distance = await locationBloc.getDistanceFromCurrentPosition(
            latitude: pos.position!.coordinates[1],
            longitude: pos.position!.coordinates[0]);
        bags.add(BagX(distance, pos));
      });
      bags.sort((a, b) => a.distance.compareTo(b.distance));
      return bags.first.position;
    }
  }

  bool isWithinDistance = false;
  ProjectPosition? nearestProjectPosition;
  static const mm = '🍏 🍏 🍏 ProjectMonitorMobile: 🍏 : ';

  Future<bool> _checkProjectDistance() async {
    pp('$mm _checkProjectDistance ... ');
    setState(() {
      isBusy = true;
    });
    nearestProjectPosition = await _findNearestProjectPosition();
    if (nearestProjectPosition != null) {
      var distance = await locationBloc.getDistanceFromCurrentPosition(
          latitude: nearestProjectPosition!.position!.coordinates[1],
          longitude: nearestProjectPosition!.position!.coordinates[0]);

      pp("$mm App is ${distance.toStringAsFixed(
          1)} metres from the project point; widget.project.monitorMaxDistanceInMetres: "
          "${widget.project.monitorMaxDistanceInMetres}");
      if (distance > widget.project.monitorMaxDistanceInMetres!) {
        pp("🔆🔆🔆 App is ${distance.toStringAsFixed(
            1)} metres is greater than allowed project.monitorMaxDistanceInMetres: "
            "🍎 ${widget.project.monitorMaxDistanceInMetres} metres");
        isWithinDistance = false;
      } else {
        isWithinDistance = true;
        pp(
            '🌸 🌸 🌸 The app is within the allowable project.monitorMaxDistanceInMetres of '
                '${widget.project.monitorMaxDistanceInMetres} metres');
      }
      setState(() {
        isBusy = false;
      });
      return isWithinDistance;
    } else {
      pp('$mm _checkProjectDistance ... 🚾 🚾 🚾 WE ARE NOT CLOSE TO THIS PROJECT POSITIONS!');
      isWithinDistance = false;
    }
    setState(() {
      isBusy = false;
    });
    return false;
  }

  void _startMonitoring() async {
    pp('🍏 🍏 Start Monitoring this project after checking that the device is within '
        ' 🍎 ${widget.project.monitorMaxDistanceInMetres} metres 🍎 of a project point within ${widget.project.name}');
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: MediaHouse(
              project: widget.project,
              projectPosition: nearestProjectPosition!,
            )));
  }

  _showError() {
    AppSnackbar.showErrorSnackbar(
        scaffoldKey: _key,
        actionLabel: '',
        message:
            "You are too far from the project for monitoring to work properly");
    setState(() {
      isBusy = false;
    });
  }

  void _navigateToDirections() async {
    pp('🏖 🍎 🍎 🍎 start Google Maps Directions .....');
    nearestProjectPosition = await _findNearestProjectPosition();
    if (nearestProjectPosition != null) {
      pp('🏖 🍎 🍎 🍎 start Google Maps Directions ..... '
          'nearestProjectPosition: ${nearestProjectPosition!.toJson()}');
      var destination =
          '${nearestProjectPosition!.position!
          .coordinates[1]},${nearestProjectPosition!.position!.coordinates[0]}';
      var position = await locationBloc.getLocation();
      var origin = '${position.latitude},${position.longitude}';

      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                  origin +
                  "&destination=" +
                  destination +
                  "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    }
  }

  void _navigateToProjectLocation() async {
    pp('🏖 🍎 🍎 🍎 ... _navigateToProjectLocation ....');
    var projectPosition = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.topLeft,
            duration: Duration(seconds: 1),
            child: ProjectLocationMain(widget.project)));
    if (projectPosition != null) {
      if (projectPosition is ProjectPosition) {
        if (widget.project.projectPositions == null) {
          widget.project.projectPositions = [];
        }
        widget.project.projectPositions!.add(projectPosition);
        _checkProjectDistance();
      }
    }
  }
}

class BagX {
  double distance;
  ProjectPosition position;

  BagX(this.distance, this.position);
}
