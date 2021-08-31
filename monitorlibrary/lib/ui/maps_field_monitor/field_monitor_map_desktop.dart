import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/snack.dart';

import '../../functions.dart';

class FieldMonitorMapDesktop extends StatefulWidget {
  final User user;

  FieldMonitorMapDesktop(this.user);

  @override
  _FieldMonitorMapDesktopState createState() => _FieldMonitorMapDesktopState();
}

class _FieldMonitorMapDesktopState extends State<FieldMonitorMapDesktop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Completer<GoogleMapController> _mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var random = Random(DateTime.now().millisecondsSinceEpoch);
  var _key = GlobalKey<ScaffoldState>();
  bool busy = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GoogleMapController? googleMapController;
  Future<void> _addMarker(double latitude, double longitude) async {
    pp('💜 💜 💜 💜 💜 💜 FieldMonitorMapDesktop: _addMarker: ....... 🍎 $latitude $longitude');
    markers.clear();

    final MarkerId markerId =
        MarkerId('${DateTime.now().millisecondsSinceEpoch}');
    final Marker marker = Marker(
      markerId: markerId,
      // icon: markerIcon,
      position: LatLng(
        latitude,
        longitude,
      ),
      infoWindow: InfoWindow(
          title: widget.user.name,
          snippet: 'Field Monitor Located Around Here'),
      onTap: () {
        _onMarkerTapped();
      },
    );
    markers[markerId] = marker;

    final CameraPosition _first = CameraPosition(
      target: LatLng(
        latitude,
        longitude,
      ),
      zoom: 14.4746,
    );
    googleMapController = await _mapController.future;
    googleMapController!.animateCamera(CameraUpdate.newCameraPosition(_first));
  }

  void _onMarkerTapped() {
    pp('💜 💜 💜 💜 💜 💜 FieldMonitorMapDesktop: _onMarkerTapped ....... ');
  }

  void _onMapTapped(LatLng argument) {
    pp('_onMapTapped: 🍎 🍎 🍎 $argument');
    _updateUser(argument.latitude, argument.longitude);
  }

  void _onLongPress(LatLng argument) {
    pp('_onLongPress: 🍎 🍎 🍎 $argument');
    _updateUser(argument.latitude, argument.longitude);
  }

  void _updateUser(double lat, double lng) async {
    pp('💜 💜 💜 💜 💜 💜 FieldMonitorMapDesktop: _updateUser ....... ');
    setState(() {
      busy = true;
    });
    try {
      widget.user.position = Position(coordinates: [lng, lat], type: 'Point');
      var result = await DataAPI.updateUser(widget.user);
      pp('💜 💜 💜 💜 💜 💜 Response : ${result.toJson()}');
    } catch (e) {
      pp(e);
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'User Update Failed: $e');
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
          title: Text(
            widget.user.name!,
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Locate the FieldMonitor at their Home base. This enables you to match projects with monitors during the onboarding process ',
                      style: Styles.whiteSmall,
                    ),
                    SizedBox(
                      height: 16,
                    )
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(40)),
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
              onTap: _onMapTapped,
              onLongPress: _onLongPress,
            ),
          ],
        ),
      ),
    );
  }

  @override
  onClose() {
    ScaffoldMessenger.of(_key.currentState!.context).removeCurrentSnackBar();
  }
}
