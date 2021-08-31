import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/position.dart';

class User {
  String? name,
      userId,
      email,
      cellphone,
      created,
      userType,
      organizationName,
      fcmRegistration,
      organizationId;
  Position? position;

  User(
      {required this.name,
      required this.email,
      required this.userId,
      required this.cellphone,
      required this.created,
      required this.userType,
      required this.organizationName,
      required this.organizationId,
      this.position,
      this.fcmRegistration});

  User.fromJson(Map data) {
    this.name = data['name'];
    this.userId = data['userId'];
    this.fcmRegistration = data['fcmRegistration'];
    this.email = data['email'];
    this.cellphone = data['cellphone'];
    this.created = data['created'];
    this.userType = data['userType'];
    this.organizationId = data['organizationId'];
    this.organizationName = data['organizationName'];
    if (data['position'] != null) {
      this.position = Position.fromJson(data['position']);
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'userId': userId,
      'fcmRegistration': fcmRegistration,
      'email': email,
      'cellphone': cellphone,
      'created': created,
      'userType': userType,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'position': position == null ? null : position!.toJson(),
    };
    return map;
  }
}

const FIELD_MONITOR = 'FIELD_MONITOR';
const ORG_ADMINISTRATOR = 'ORG_ADMINISTRATOR';
const ORG_EXECUTIVE = 'ORG_EXECUTIVE';
const NETWORK_ADMINISTRATOR = 'NETWORK_ADMINISTRATOR';
const ORG_OWNER = 'ORG_OWNER';

const MONITOR_ONCE_A_DAY = 'Once Every Day';
const MONITOR_TWICE_A_DAY = 'Twice A Day';
const MONITOR_THREE_A_DAY = 'Three Times A Day';
const MONITOR_ONCE_A_WEEK = 'Once A Week';

const labels = [
  'Once Every Day',
  'Twice A Day',
  'Three Times A Day',
  'Once A Week',
  'Once A Month',
  'Whenever Necessary'
];

class OrgMessage {
  String? name, userId, message, created, organizationId, projectId;
  String? projectName, adminId, adminName;
  String? frequency, result;

  OrgMessage(
      {required this.name,
      required this.message,
      required this.userId,
      required this.created,
      required this.projectId,
      required this.projectName,
      required this.adminId,
      required this.adminName,
      required this.frequency,
      required this.organizationId});

  OrgMessage.fromJson(Map data) {
    this.name = data['name'];
    this.userId = data['userId'];
    this.message = data['message'];
    this.created = data['created'];
    this.organizationId = data['organizationId'];
    this.projectId = data['projectId'];
    this.projectName = data['projectName'];
    this.adminId = data['adminId'];
    this.adminName = data['adminName'];
    this.frequency = data['frequency'];
    this.result = data['result'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'userId': userId,
      'message': message,
      'created': created,
      'organizationId': organizationId,
      'projectId': projectId,
      'projectName': projectName,
      'adminId': adminId,
      'adminName': adminName,
      'frequency': frequency,
      'result': result,
    };
    return map;
  }
}
