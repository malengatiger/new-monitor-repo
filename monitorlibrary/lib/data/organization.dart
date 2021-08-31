import 'package:meta/meta.dart';

class Organization {
  String? name, countryId, organizationId, email, countryName, created;

  Organization(
      {required this.name,
      required this.countryId,
      required this.email,
      required this.created,
      required this.countryName,
      required this.organizationId});

  Organization.fromJson(Map data) {
    this.name = data['name'];
    this.countryId = data['countryId'];
    this.organizationId = data['organizationId'];
    this.email = data['email'];
    this.countryName = data['countryName'];
    this.organizationId = data['organizationId'];
    this.created = data['created'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'created': created,
      'countryId': countryId,
      'organizationId': organizationId,
      'email': email,
      'countryName': countryName,
      'organizationId': organizationId,
    };
    return map;
  }
}
