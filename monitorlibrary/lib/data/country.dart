import 'package:meta/meta.dart';

class Country {
  String? name, countryId, countryCode;
  int population = 0;
  Country(
      {required this.name,
        required this.population,
        required this.countryCode});

  Country.fromJson(Map data) {
    this.name = data['name'];
    this.countryId = data['countryId'];
    this.countryCode = data['countryCode'];
    this.population = data['population'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'countryId': countryId,
      'countryCode': countryCode,
      'population': population,
    };
    return map;
  }
}
