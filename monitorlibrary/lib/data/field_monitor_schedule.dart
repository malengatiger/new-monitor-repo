import 'package:meta/meta.dart';

class FieldMonitorSchedule {
  String? fieldMonitorScheduleId,
      fieldMonitorId,
      adminId,
      organizationId,
      projectId,
      projectName,
      date,
      organizationName;
  int? perDay, perWeek, perMonth;

  FieldMonitorSchedule(
      {required this.fieldMonitorId,
      required this.adminId,
      required this.projectId,
      required this.date,
      required this.fieldMonitorScheduleId,
      this.perDay,
      this.perWeek,
      this.perMonth,
      this.projectName,
      this.organizationName,
      required this.organizationId});

  FieldMonitorSchedule.fromJson(Map data) {
    this.fieldMonitorId = data['fieldMonitorId'];
    this.fieldMonitorScheduleId = data['fieldMonitorScheduleId'];
    this.adminId = data['adminId'];
    this.organizationId = data['organizationId'];
    this.projectId = data['projectId'];
    this.projectName = data['projectName'];
    this.organizationName = data['organizationName'];
    this.perDay = data['perDay'];
    this.perWeek = data['perWeek'];
    this.perMonth = data['perMonth'];
    this.date = data['date'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'fieldMonitorId': fieldMonitorId,
      'fieldMonitorScheduleId': fieldMonitorScheduleId,
      'date': date,
      'adminId': adminId,
      'organizationId': organizationId,
      'projectId': projectId,
      'projectName': projectName,
      'organizationName': organizationName,
      'perDay': perDay,
      'perWeek': perWeek,
      'perMonth': perMonth,
    };
    return map;
  }
}
