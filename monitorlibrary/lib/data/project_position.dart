import 'package:geocoding/geocoding.dart';
import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/position.dart' as ar;

import '../functions.dart';
import 'city.dart';

class ProjectPosition {
  String? projectName, projectId, caption, created, projectPositionId, organizationId;
  ar.Position? position;
  Placemark? placemark;
  List<City>? nearestCities;

  ProjectPosition(
      {required this.projectName,
      required this.caption,
        required this.projectPositionId,
      required this.created,
      required this.position,
      this.placemark,
      required this.nearestCities,
        required this.organizationId,
      required this.projectId});

  ProjectPosition.fromJson(Map data) {
    //pp(' 💜 ProjectPosition.fromJson: log 0');
    this.projectName = data['projectName'];
    //pp(' 💜 ProjectPosition.fromJson: log 1');
    this.projectId = data['projectId'];
    this.projectPositionId = data['projectPositionId'];
    //pp(' 💜 ProjectPosition.fromJson: log 2');
    this.caption = data['caption'];
    this.projectId = data['projectId'];
    this.organizationId = data['organizationId'];
    this.created = data['created'];
    //pp(' 💜 ProjectPosition.fromJson: log 3');

    if (data['position'] != null) {
      this.position = ar.Position.fromJson(data['position']);
    }
    //pp(' 💜 ProjectPosition.fromJson: log 4');
    if (data['placemark'] != null) {
      this.placemark = Placemark.fromMap(data['position']);
    }
    //pp(' 💜 ProjectPosition.fromJson: log 5');
    this.nearestCities = [];
    if (data['nearestCities'] != null) {
      List list = data['nearestCities'];
      list.forEach((c) {
        nearestCities!.add(City.fromJson(c));
      });
    }
    //pp(' 💜 ProjectPosition.fromJson: log end');
  }

  Map<String, dynamic> toJson() {
    var list = [];
    this.nearestCities!.forEach((c) {
      list.add(c.toJson());
    });
    Map<String, dynamic> map = {
      'projectName': projectName,
      'projectId': projectId,
      'organizationId': organizationId,
      'projectPositionId': projectPositionId,
      'caption': caption,
      'created': created,
      'position': position == null ? null : position!.toJson(),
      'placemark': placemark == null ? null : placemark!.toJson(),
      'nearestCities': list,
    };
    return map;
  }
}
