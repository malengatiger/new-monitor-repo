import 'package:meta/meta.dart';

class Organization {
  String name, countryId, organizationId, email, countryName;

  Organization(
      {@required this.name,
      @required this.countryId,
      @required this.email,
      this.countryName,
      @required this.organizationId});

  Organization.fromJson(Map data) {
    this.name = data['name'];
    this.countryId = data['countryId'];
    this.organizationId = data['organizationId'];
    this.email = data['email'];
    this.countryName = data['countryName'];
    this.organizationId = data['organizationId'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'countryId': countryId,
      'organizationId': organizationId,
      'email': email,
      'countryName': countryName,
      'organizationId': organizationId,
    };
    return map;
  }
}
