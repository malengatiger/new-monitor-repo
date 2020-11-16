import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/position.dart';

class ProjectPosition {
  String projectName, projectId, caption, created;
  Position position;

  ProjectPosition(
      {@required this.projectName,
      @required this.caption,
      @required this.created,
      @required this.position,
      @required this.projectId});

  ProjectPosition.fromJson(Map data) {
    this.projectName = data['projectName'];
    this.projectId = data['projectId'];
    this.caption = data['caption'];
    this.projectId = data['projectId'];
    this.created = data['created'];

    if (data['position'] != null) {
      this.position = Position.fromJson(data['position']);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'projectName': projectName,
      'projectId': projectId,
      'caption': caption,
      'created': created,
      'position': position == null ? null : position.toJson(),
    };
    return map;
  }
}
