import 'package:meta/meta.dart';

class City {
  String name, countryId, countryName, provinceName, cityId, created;
  dynamic position;

  City(
      {@required this.name,
      @required this.countryId,
      @required this.provinceName,
      @required this.countryName,
      @required this.position,
      @required this.created});

  City.fromJson(Map data) {
    this.name = data['name'];
    this.countryId = data['countryId'];
    this.countryName = data['countryName'];
    this.provinceName = data['provinceName'];
    this.countryName = data['countryName'];
    this.created = data['created'];
    this.cityId = data['cityId'];
    this.position = data['position'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'countryId': countryId,
      'countryName': countryName,
      'provinceName': provinceName,
      'countryName': countryName,
      'cityId': cityId,
      'position': position,
      'created': created,
    };
    return map;
  }
}
