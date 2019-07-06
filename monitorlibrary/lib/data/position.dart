import 'package:meta/meta.dart';

class Position {
  List coordinates;
  String type = 'Point', createdAt;
  int  index;
  Position({
    @required this.coordinates,
    @required this.type,
    this.index,
  });

  Position.fromJson(Map data) {
    this.coordinates = data['coordinates'];
    this.type = data['type'];
    this.index = data['index'];
    this.createdAt = data['createdAt'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type,
      'coordinates': coordinates,
      'index': index,
      'createdAt': createdAt,
    };
    return map;
  }
}
