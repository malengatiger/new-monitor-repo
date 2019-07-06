import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/position.dart';

class Content {
  String url;
  String userId, created;
  String comment;
  Position position;
  Content(
      {@required this.url,
      @required this.userId,
      this.comment,
      @required this.position,
      this.created});

  Content.fromJson(Map data) {
    this.url = data['url'];
    this.userId = data['userId'];
    this.comment = data['comment'];
    this.created = data['created'];
    this.position = data['position'];
  }
  
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'userId': userId,
      'url': url,
      'comment': comment,
      'created': created,
      'position': position,
    };
    return map;
  }
}
