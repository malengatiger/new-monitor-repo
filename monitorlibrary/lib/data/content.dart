import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/position.dart';

class Content {
  String? url;
  String? userId, created;
  Position? position;
  Content(
      {required this.url,
      required this.userId,
      required this.position,
      this.created});

  Content.fromJson(Map data) {
    this.url = data['url'];
    this.userId = data['userId'];
    this.created = data['created'];
    if (data['position'] != null) {
      this.position = Position.fromJson(data['position']);
    }
  }
  
  Map<String, dynamic> toJson() {
    Map pos = Map();
    if (position != null) {
      pos = position!.toJson();
    }
    Map<String, dynamic> map = {
      'userId': userId,
      'url': url,
      'created': created,
      'position': pos,
    };
    return map;
  }
}
