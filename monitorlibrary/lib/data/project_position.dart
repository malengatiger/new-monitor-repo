import 'package:geocoding/geocoding.dart';
import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/position.dart' as ar;

import 'city.dart';

class ProjectPosition {
  String projectName, projectId, caption, created;
  ar.Position position;
  Placemark placemark;
  List<City> nearestCities;

  ProjectPosition(
      {@required this.projectName,
      @required this.caption,
      @required this.created,
      @required this.position,
      @required this.placemark,
      @required this.nearestCities,
      @required this.projectId});

  ProjectPosition.fromJson(Map data) {
    this.projectName = data['projectName'];
    this.projectId = data['projectId'];
    this.caption = data['caption'];
    this.projectId = data['projectId'];
    this.created = data['created'];

    if (data['position'] != null) {
      this.position = ar.Position.fromJson(data['position']);
    }
    if (data['placemark'] != null) {
      this.placemark = Placemark.fromMap(data['position']);
    }
    this.nearestCities = [];
    if (data['nearestCities'] != null) {
      List list = data['nearestCities'];
      list.forEach((c) {
        nearestCities.add(City.fromJson(c));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var list = [];
    this.nearestCities.forEach((c) {
      list.add(c.toJson());
    });
    Map<String, dynamic> map = {
      'projectName': projectName,
      'projectId': projectId,
      'caption': caption,
      'created': created,
      'position': position == null ? null : position.toJson(),
      'placemark': placemark == null ? null : placemark.toJson(),
      'nearestCities': list,
    };
    return map;
  }
}
