import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';

import '../../functions.dart';

class ProjectMapMobile extends StatefulWidget {
  final Project project;
  final List<ProjectPosition> projectPositions;
  final Photo photo;

  ProjectMapMobile(
      {@required this.project, @required this.projectPositions, this.photo});

  @override
  _ProjectMapMobileState createState() => _ProjectMapMobileState();
}

class _ProjectMapMobileState extends State<ProjectMapMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Completer<GoogleMapController> _mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var random = Random(DateTime.now().millisecondsSinceEpoch);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _addMarkers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GoogleMapController googleMapController;
  Future<void> _addMarkers() async {
    pp('💜 💜 💜 💜 💜 💜 ProjectMapMobile: _addMarkers: ....... 🍎 ${widget.projectPositions.length}');
    markers.clear();
    widget.projectPositions.forEach((projectPosition) {
      final MarkerId markerId =
          MarkerId('${projectPosition.projectId}_${random.nextInt(9999988)}');
      final Marker marker = Marker(
        markerId: markerId,
        // icon: markerIcon,
        position: LatLng(
          projectPosition.position.coordinates.elementAt(1),
          projectPosition.position.coordinates.elementAt(0),
        ),
        infoWindow: InfoWindow(
            title: projectPosition.projectName,
            snippet: 'Project Located Here'),
        onTap: () {
          _onMarkerTapped(projectPosition);
        },
      );
      markers[markerId] = marker;
    });
    final CameraPosition _first = CameraPosition(
      target: LatLng(
          widget.projectPositions
              .elementAt(0)
              .position
              .coordinates
              .elementAt(1),
          widget.projectPositions
              .elementAt(0)
              .position
              .coordinates
              .elementAt(0)),
      zoom: 14.4746,
    );
    googleMapController = await _mapController.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(_first));
  }

  void _onMarkerTapped(ProjectPosition projectPosition) {
    pp('💜 💜 💜 💜 💜 💜 ProjectMapMobile: _onMarkerTapped ....... ${projectPosition.projectName}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.project.name,
            style: Styles.whiteSmall,
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              mapToolbarEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                googleMapController = controller;
              },
              myLocationEnabled: true,
              markers: Set<Marker>.of(markers.values),
            ),
            widget.photo != null
                ? Positioned(
                    left: 12,
                    top: 12,
                    child: Card(
                      elevation: 8,
                      color: Colors.black26,
                      child: Container(
                        height: 180,
                        width: 160,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Image.network(
                              widget.photo.thumbnailUrl,
                              width: 140,
                              height: 140,
                              fit: BoxFit.fill,
                            ),
                            Text(
                              '${getFormattedDateShortestWithTime(widget.photo.created, context)}',
                              style: Styles.whiteTiny,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
