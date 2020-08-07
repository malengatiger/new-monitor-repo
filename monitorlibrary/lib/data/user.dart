import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/*
data class User(var name: String, var email: String, var cellphone: String, var userId: String?,
                var organizationId: String, var organizationName: String, var created: String, var userType: UserType) {
 */
class User {
  String name,
      userId,
      email,
      cellphone,
      created,
      userType,
      organizationName,
      organizationId;

  User(
      {@required this.name,
      @required this.email,
      this.cellphone,
      @required this.created,
      @required this.userType,
      @required this.organizationName,
      @required this.organizationId});

  User.fromJson(Map data) {
    this.name = data['name'];
    this.userId = data['userId'];
    this.email = data['email'];
    this.cellphone = data['cellphone'];
    this.created = data['created'];
    this.userType = data['userType'];
    this.organizationId = data['organizationId'];
    this.organizationName = data['organizationName'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'userId': userId,
      'email': email,
      'cellphone': cellphone,
      'created': created,
      'userType': userType,
      'organizationId': organizationId,
      'organizationName': organizationName,
    };
    return map;
  }
}
