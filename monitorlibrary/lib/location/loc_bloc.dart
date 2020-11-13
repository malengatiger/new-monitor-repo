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
}
