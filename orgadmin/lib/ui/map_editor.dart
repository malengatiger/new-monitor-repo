import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:orgadmin/admin_bloc.dart';

class MapEditor extends StatefulWidget {
  final Settlement settlement;

  MapEditor(this.settlement);

  @override
  _MapEditorState createState() => _MapEditorState();
}

class _MapEditorState extends State<MapEditor> implements SnackBarListener {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Completer<GoogleMapController> _completer = Completer();
  GoogleMapController _mapController;
  Position position;
  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(-27.7, 25.7),
    zoom: 14.0,
  );
  MapType mapType;
  Set<Marker> _markersForMap = Set();
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  _getLocation() async {
    position = await adminBloc.getCurrentLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Settlement Map Editor'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Column(
            children: <Widget>[
              Text(
                '${widget.settlement.settlementName}',
                style: Styles.blackBoldMedium,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
              initialCameraPosition: _cameraPosition,
              mapType: mapType == null ? MapType.hybrid : mapType,
              markers: _markersForMap,
              myLocationEnabled: true,
              compassEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              onLongPress: _onMapLongPressed,
              onMapCreated: (mapController) {
                debugPrint(
                    '🔆🔆🔆🔆🔆🔆 onMapCreated ... markersMap ...  🔆🔆🔆🔆');
                _completer.complete(mapController);
                _mapController = mapController;
                _markSomething();
              }),
        ],
      ),
    );
  }

  _markSomething() async {
    debugPrint('mark something ......... map not showing up');
    if (position != null) {
      var latLng = LatLng(position.coordinates[1], position.coordinates[0]);
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
    }
  }

  LatLng latLng;
  void _onMapLongPressed(LatLng p) {
    print('🥏 Map long pressed 🥏 🥏 $p ...');
    latLng = p;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
              title: new Text(
                "Confirm Point",
                style: Styles.blackBoldLarge,
              ),
              content: Container(
                height: 40.0,
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.settlement == null
                          ? ''
                          : widget.settlement.settlementName,
                      style: Styles.blackSmall,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'NO',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: RaisedButton(
                    onPressed: () {
                      print('🍏 onPressed');
                      _addPointToPolygon();
                    },
                    elevation: 4.0,
                    color: Colors.pink.shade700,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Add to Polygon',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ));
  }

  _addPointToPolygon() async {
    print('🔸🔸🔸 _addPointToPolygon: $latLng');
    Navigator.pop(context);
    var marker = Marker(
        onTap: () {
          debugPrint('marker tapped!! ❤️ 🧡 💛 :latLng: $latLng ');
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        markerId: MarkerId(DateTime.now().toIso8601String()),
        position: LatLng(latLng.latitude, latLng.longitude),
        infoWindow: InfoWindow(
            title: '${DateTime.now().toIso8601String()}',
            snippet: 'Point in Settlement Polygon',
            onTap: () {
              debugPrint(' 🧩 🧩 🧩 infoWindow tapped  🧩 🧩 🧩 ');
            }));
    _markersForMap.add(marker);
    setState(() {});

    AppSnackbar.showSnackbarWithProgressIndicator(
        scaffoldKey: _key,
        message: 'Adding point to polygon',
        textColor: Colors.blue,
        backgroundColor: Colors.black);

    try {
      var res = await adminBloc.addToPolygon(
          settlementId: widget.settlement.settlementId,
          latitude: latLng.latitude,
          longitude: latLng.longitude);
      _key.currentState.removeCurrentSnackBar();
      print(res);
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key,
          message: e.message,
          actionLabel: 'Err',
          listener: this);
    }
  }

  @override
  onActionPressed(int action) {
    // TODO: implement onActionPressed
    return null;
  }
}
