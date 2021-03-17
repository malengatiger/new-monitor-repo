import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/location/loc_bloc.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:monitorlibrary/users/special_snack.dart';

import '../../functions.dart';

class FieldMonitorMapMobile extends StatefulWidget {
  final User user;

  FieldMonitorMapMobile(this.user);

  @override
  _FieldMonitorMapMobileState createState() => _FieldMonitorMapMobileState();
}

class _FieldMonitorMapMobileState extends State<FieldMonitorMapMobile>
    with SingleTickerProviderStateMixin
    implements SpecialSnackListener {
  AnimationController _controller;
  Completer<GoogleMapController> _mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var random = Random(DateTime.now().millisecondsSinceEpoch);
  var _key = GlobalKey<ScaffoldState>();
  bool busy = false;
// -25.7605441 longitude: 27.8525941
  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(-25.7705441, 27.8525941),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    var pos = await locationBloc.getLocation();
    setState(() {
      _cameraPosition = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 14.4746,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GoogleMapController googleMapController;
  Future<void> _addMarker(double latitude, double longitude) async {
    pp('💜 💜 💜 💜 💜 💜 FieldMonitorMapMobile: _addMarker: ....... 🍎 $latitude $longitude');
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
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(_first));
  }

  void _onMarkerTapped() {
    pp('💜 💜 💜 💜 💜 💜 FieldMonitorMapMobile: _onMarkerTapped ....... ');
  }

  void _onLongPress(LatLng argument) {
    pp('_onLongPress: 🍎 🍎 🍎 $argument');
    _addMarker(argument.latitude, argument.longitude);
    _updateUser(argument.latitude, argument.longitude);
  }

  void _updateUser(double lat, double lng) async {
    pp('💜 💜 💜 💜 💜 💜 FieldMonitorMapMobile: _updateUser ....... ');
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
            widget.user.name,
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
                    ),
                    Text(
                      'Press and Hold to locate FieldMonitor',
                      style: Styles.blackBoldSmall,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(110)),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: _cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                pp('GoogleMap:onMapCreated ....');
                _mapController.complete(controller);
                googleMapController = controller;
                if (widget.user.position != null) {
                  _addMarker(widget.user.position.coordinates.elementAt(1),
                      widget.user.position.coordinates.elementAt(1));
                }
              },
              myLocationEnabled: true,
              markers: Set<Marker>.of(markers.values),
              onLongPress: _onLongPress,
            ),
            busy
                ? Positioned(
                    left: 60,
                    top: 60,
                    child: Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                        backgroundColor: Colors.amber,
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  onClose() {
    ScaffoldMessenger.of(_key.currentState.context).removeCurrentSnackBar();
  }
}
