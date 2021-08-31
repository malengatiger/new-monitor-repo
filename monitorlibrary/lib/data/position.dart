import 'package:meta/meta.dart';

class Position {
  List coordinates = [];
  String? type = 'Point';
  Position({
    required this.coordinates,
    required this.type,
  });

  Position.fromJson(Map data) {
    this.coordinates = data['coordinates'];
    this.type = data['type'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'type': type,
      'coordinates': coordinates,
    };
    return map;
  }
}
