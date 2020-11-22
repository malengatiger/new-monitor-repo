import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class User {
  String name,
      _id,
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
      @required this.cellphone,
      @required this.created,
      @required this.userType,
      @required this.organizationName,
      @required this.organizationId});

  User.fromJson(Map data) {
    this.name = data['name'];
    this.userId = data['userId'];
    this._id = data['_id'];
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
      '_id': _id,
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

const FIELD_MONITOR = 'FIELD_MONITOR';
const ORG_ADMINISTRATOR = 'ORG_ADMINISTRATOR';
const ORG_EXECUTIVE = 'ORG_EXECUTIVE';
const NETWORK_ADMINISTRATOR = 'NETWORK_ADMINISTRATOR';
const ORG_OWNER = 'ORG_OWNER';
