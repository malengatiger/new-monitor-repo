import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monitorlibrary/functions.dart';

final LocationBloc locationBloc = LocationBloc();

class LocationBloc {
  Future<Position> getLocation() async {
    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    pp('🔆🔆🔆 Location has been found:  💜 latitude: ${pos.latitude} longitude: ${pos.longitude}');
    return pos;
  }

  Future<LocationPermission> checkPermission() async {
    var perm = await Geolocator.checkPermission();
    return perm;
  }

  Future<LocationPermission> requestPermission() async {
    var perm = await Geolocator.requestPermission();
    return perm;
  }

  Future<double> getDistanceFromCurrentPosition(
      {@required double latitude, @required double longitude}) async {
    assert(latitude != null);
    assert(longitude != null);
    var pos = await getLocation();

    return Geolocator.distanceBetween(
        latitude, longitude, pos.latitude, pos.longitude);
  }
}
