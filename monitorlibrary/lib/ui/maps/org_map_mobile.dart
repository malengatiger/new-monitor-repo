import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monitorlibrary/api/local_mongo.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';

import '../../functions.dart';

class OrganizationMapMobile extends StatefulWidget {
  @override
  _OrganizationMapMobileState createState() => _OrganizationMapMobileState();
}

class _OrganizationMapMobileState extends State<OrganizationMapMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Completer<GoogleMapController> _mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var random = Random(DateTime.now().millisecondsSinceEpoch);
  var _key = GlobalKey<ScaffoldState>();
  static const DEFAULT_ZOOM = 10.0;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-25.42796133580664, 26.085749655962),
    zoom: DEFAULT_ZOOM,
  );

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getProjectPositions();
  }

  List<ProjectPosition> _positions = [];
  void _getProjectPositions() async {
    _positions = await LocalMongo.getOrganizationProjectPositions();
    _addMarkers();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GoogleMapController? googleMapController;
  Future<void> _addMarkers() async {
    pp('💜 💜 💜 💜 💜 💜 OrganizationMapMobile: _addMarkers: ....... 🍎 ${_positions.length}');
    markers.clear();
    _positions.forEach((projectPosition) {
      final MarkerId markerId =
          MarkerId('${projectPosition.projectId}_${random.nextInt(9999988)}');
      final Marker marker = Marker(
        markerId: markerId,
        // icon: markerIcon,
        position: LatLng(
          projectPosition.position!.coordinates.elementAt(1),
          projectPosition.position!.coordinates.elementAt(0),
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
      target: LatLng(_positions.elementAt(0).position!.coordinates.elementAt(1),
          _positions.elementAt(0).position!.coordinates.elementAt(0)),
      zoom: DEFAULT_ZOOM,
    );
    googleMapController = await _mapController.future;
    googleMapController!.animateCamera(CameraUpdate.newCameraPosition(_first));
  }


  void _onMarkerTapped(ProjectPosition projectPosition) {
    pp('💜 💜 💜 💜 💜 💜 OrganizationMapMobile: _onMarkerTapped ....... ${projectPosition.projectName}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            'Organization Project Locations',
            style: Styles.whiteSmall,
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              mapToolbarEnabled: true,
              initialCameraPosition: _kGooglePlex,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: true, compassEnabled: true, buildingsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                googleMapController = controller;
              },
              myLocationEnabled: true,
              markers: Set<Marker>.of(markers.values),
            ),
          ],
        ),
      ),
    );
  }
}
