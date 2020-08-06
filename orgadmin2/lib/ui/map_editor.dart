import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';

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
  CameraPosition _cameraPosition;
  MapType mapType;
  Set<Marker> _markersForMap = Set();
  @override
  void initState() {
    super.initState();
    print('📯📯 polygon has 📯 ${widget.settlement.polygon.length} points. 📯 if > 2 must draw polygon');
    _getLocation();
    _setPoints();
    _setMarkers();
  }

  _getLocation() async {
    position = await bloc.getCurrentLocation();
    print('💠💠💠 setting new camera position  💠💠💠 after getting current location ${position.coordinates}');
    _cameraPosition = CameraPosition(
      target: LatLng(position.coordinates[1], position.coordinates[0]),
      zoom: 12.0,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Settlement Map Editor'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.cancel),
          onPressed: _confirmRemovePolygons,),
          IconButton(icon: Icon(Icons.create_new_folder),
            onPressed: _drawPolygon,),
        ],
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
          _cameraPosition == null? Container() :
          GoogleMap(
              initialCameraPosition: _cameraPosition,
              mapType: mapType == null ? MapType.hybrid : mapType,
              markers: _markersForMap,
              polygons: polygons,
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
                if (points.isEmpty) {
                  print('No points in polygon ... 🌍 🌍 🌍  try to place map at current location');
                } else {
                  if (points.length < 3) {
                    _setMarkers();
                  } else {
                    _setMarkers();
                    _drawPolygon();
                  }
                }
              }),
        ],
      ),
    );
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
    _placeNewMarker();
    points.add(latLng);
    _setMarkers();
    setState(() {});

    AppSnackbar.showSnackbarWithProgressIndicator(
        scaffoldKey: _key,
        message: 'Adding point to polygon',
        textColor: Colors.blue,
        backgroundColor: Colors.black);

    try {
      var res = await bloc.addToPolygon(
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

  void _placeNewMarker() {
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
//    if (_mapController != null) {
//      //_mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 12));
//      _mapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 12));
//      setState(() {
//
//      });
//    }
  }

  void _setMarkers() {
    _markersForMap.clear();
    if (points.isEmpty) return;
    debugPrint('Setting  🏮 🏮 ${points.length} 🏮 🏮 markers on map');
    points.forEach((p) {
      var marker = Marker(
          onTap: () {
            debugPrint('marker tapped!! ❤️ 🧡 💛 :latLng: $latLng ');
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          markerId: MarkerId(DateTime.now().toIso8601String()),
          position: LatLng(p.latitude, p.longitude),
          infoWindow: InfoWindow(
              title: '${DateTime.now().toIso8601String()}',
              snippet: 'Point in Settlement Polygon',
              onTap: () {
                debugPrint(' 🧩 🧩 🧩 infoWindow tapped  🧩 🧩 🧩 ');
              }));
      _markersForMap.add(marker);
    });
    if (_mapController != null) {
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(points[0], 14));
      setState(() {

      });
    }

  }

  List<LatLng> points = List();
  Set<Polygon> polygons = Set();

  _drawPolygon() {
    if (points.isEmpty) return;
    debugPrint('Drawing polygon from  🏮 🏮 ${points.length} 🏮 🏮 points');
    polygons.clear();
    var pol = Polygon(
        polygonId: PolygonId('${DateTime.now().microsecondsSinceEpoch}'),
        points: points,
        geodesic: true,
        strokeColor: Colors.yellow,
        fillColor: Colors.transparent);
    polygons.add(pol);
    setState(() {

    });
    var latLng = points[0];
    if (_mapController != null)
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
  }

  _setPoints() {
    widget.settlement.polygon.forEach((p) {
      points.add(LatLng(p.coordinates[1], p.coordinates[0]));
    });
  }
  @override
  onActionPressed(int action) {
    // TODO: implement onActionPressed
    return null;
  }

  void _confirmRemovePolygons() {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
          title: new Text(
            "Confirm Delete",
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
                  points.clear();
                  _markersForMap.clear();
                  polygons.clear();
                  setState(() {

                  });
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
}
