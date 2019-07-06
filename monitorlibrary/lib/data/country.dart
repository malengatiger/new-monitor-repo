import 'package:meta/meta.dart';

class Country {
  String name, countryId, countryCode, countryName;
  int population;
  Country(
      {@required this.name,
        this.countryName,
        this.population,
        @required this.countryCode});

  Country.fromJson(Map data) {
    this.name = data['name'];
    this.countryId = data['countryId'];
    this.countryCode = data['countryCode'];
    this.countryName = data['countryName'];
    this.population = data['population'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'countryId': countryId,
      'countryCode': countryCode,
      'countryName': countryName,
      'population': population,
    };
    return map;
  }
}
