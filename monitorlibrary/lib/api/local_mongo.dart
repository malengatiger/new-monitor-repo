import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobmongo/carrier.dart';
import 'package:mobmongo/mobmongo3.dart';
import 'package:monitorlibrary/data/city.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/field_monitor_schedule.dart';
import 'package:monitorlibrary/data/monitor_report.dart';
import 'package:monitorlibrary/data/organization.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';

import '../constants.dart';
import 'cache.dart';
final LocalMongo localMongo = LocalMongo();
class LocalMongo implements LocalDatabase {
  static const APP_ID = 'arAppID';
  bool dbConnected = false;
  static int cnt = 0;
  static const mm = '🔵 🔵 🔵 LocalDBAPI: ';

  String databaseName = 'ARDB001b';

  Future setDatabaseName({required String name}) async {
    pp('\n\n\n🔵 🔵 🔵 🔵 🔵 🔵 🔵 setDatabaseName: $name MongoDB Mobile .. . 🔵 🔵 🔵 🔵 🔵 🔵 🔵 ');
    databaseName = name;
  }

  Future setAppID() async {
    pp('\n\n🍎 🍎 🍎  setting MongoDB Mobile appID  🍎 🍎 🍎  🍎 🍎 🍎 ');
    try {
      var res = await MobMongo.setAppID({
        'appID': APP_ID,
        'type': MobMongo.LOCAL_DATABASE,
      });
      pp(res);
    } on PlatformException catch (f) {
      pp('👿👿👿👿👿👿👿👿 PlatformException 🍎 🍎 🍎 - $f');
      throw Exception(f.message);
    }
  }

  Future _connectToLocalDB() async {
    if (dbConnected) {
      return null;
    }
    pp('\n\n\n$mm .... Connecting to MongoDB Mobile ... 🔵 🔵 🔵 🔵 🔵 🔵 🔵 ');
    try {
      print('$mm 🧩 🧩 🧩_connectToLocalDB: will create indexes ......');
      await _createIndices();
      dbConnected = true;
      pp('$mm 👌 Connected to MongoDB Mobile. 🥬 DATABASE: $databaseName  🥬 APP_ID: $APP_ID  👌 👌 👌 '
          ' necessary indices created for routes and landmarks 🧩 🧩 🧩');
    } on PlatformException catch (e) {
      pp('👿👿👿👿👿👿👿👿👿👿 ${e.message}  👿👿👿👿');
      throw Exception(e);
    }
  }

  static const kk = 'LocalDBAPI: 🌼🌼 : ';
  Future _createIndices() async {
    pp('$mm _createIndices .....');
    var carr1 = Carrier(
        db: databaseName, collection: Constants.CITY, index: {"cityID": 1});
    await MobMongo.createIndex(carr1);
    var carr3 = Carrier(
        db: databaseName,
        collection: Constants.PROJECT,
        index: {"position": "2dsphere"});

    await MobMongo.createIndex(carr3);
    var carr4 = Carrier(
        db: databaseName,
        collection: Constants.PROJECT_POSITION,
        index: {"position": "2dsphere"});

    await MobMongo.createIndex(carr4);

    var carr5 = Carrier(
        db: databaseName,
        collection: Constants.PROJECT_POSITION,
        index: {"projectId": 1});

    await MobMongo.createIndex(carr5);

    var carr5a = Carrier(
        db: databaseName,
        collection: Constants.PHOTO,
        index: {"position": "2dsphere"});

    await MobMongo.createIndex(carr5a);

    var carr6 = Carrier(
        db: databaseName,
        collection: Constants.PHOTO,
        index: {"projectId": 1});
    await MobMongo.createIndex(carr6);

    var carr7 = Carrier(
        db: databaseName, collection: Constants.VIDEO, index: {"projectId": 1});
    await MobMongo.createIndex(carr7);

    var carr8 = Carrier(
        db: databaseName,
        collection: Constants.VIDEO,
        index: {"position": "2dsphere"});
    await MobMongo.createIndex(carr8);

    var carr9 = Carrier(
        db: databaseName,
        collection: Constants.MONITOR_REPORT,
        index: {"projectId": 1});
    await MobMongo.createIndex(carr9);

    var carr10 = Carrier(
        db: databaseName,
        collection: Constants.MONITOR_REPORT,
        index: {"position": "2dsphere"});
    await MobMongo.createIndex(carr10);

    var carr11 = Carrier(
        db: databaseName,
        collection: Constants.FIELD_MONITOR_SCHEDULE,
        index: {"organizationId": 1, "projectId": 1});
    await MobMongo.createIndex(carr11);

    var carr12 = Carrier(
        db: databaseName,
        collection: Constants.FIELD_MONITOR_SCHEDULE,
        index: {"projectId": 1});
    await MobMongo.createIndex(carr12);

    var carr13 = Carrier(
        db: databaseName,
        collection: Constants.FIELD_MONITOR_SCHEDULE,
        index: {"userId": 1});
    await MobMongo.createIndex(carr13);

    pp('$mm 🧩 🧩 🧩  🧩 🧩 🧩 ALL local indices built! - 👌 👌 👌');
  }

  // @override
  // Future<int> addProject(Project project) async {

  // }
  // static Future<List<Project>> getProjects() async {

  // }
  // static Future addCity(City city) async {

  // }
  // static Future addProjectPosition(ProjectPosition projectPosition) async {

  // }
  // static Future addMonitorReport(MonitorReport report) async {
  //   print('$kk .... addMonitorReport .....');
  //   await _connectToLocalDB();
  //   Carrier carrier = Carrier(
  //     db: databaseName,
  //     collection: Constants.MONITOR_REPORT,
  //   );
  //   var result = await MobMongo.insert(carrier);
  //   pp('$kk MonitorReport added to local cache: ${report.projectId}');
  //   return result;
  // }
  // static Future addUser(User user) async {
  //   print('$kk .... addUser .....');
  //   await _connectToLocalDB();
  //   Carrier carrier = Carrier(
  //     db: databaseName,
  //     collection: Constants.USER,
  //   );
  //   var result = await MobMongo.insert(carrier);
  //   pp('$kk User added to local cache: ${user.name}');
  //   return result;
  // }
  // static Future addPhoto(Photo photo) async {
  //   print('$kk .... addPhoto .....');
  //   await _connectToLocalDB();
  //   Carrier carrier = Carrier(
  //     db: databaseName,
  //     collection: Constants.PHOTO,
  //   );
  //   var result = await MobMongo.insert(carrier);
  //   pp('$kk Photo added to local cache: ${photo.projectName}');
  //   return result;
  // }
  // static Future addVideo(Video video) async {
  //   print('$kk .... addVideo .....');
  //   await _connectToLocalDB();
  //   Carrier carrier = Carrier(
  //     db: databaseName,
  //     collection: Constants.VIDEO,
  //   );
  //   var result = await MobMongo.insert(carrier);
  //   pp('$kk Video added to local cache: ${video.projectName}');
  //   return result;
  // }
  // static Future addFieldMonitorSchedule(FieldMonitorSchedule project) async {
  //   print('$kk .... addFieldMonitorSchedule .....');
  //   await _connectToLocalDB();
  //   Carrier carrier = Carrier(
  //     db: databaseName,
  //     collection: Constants.FIELD_MONITOR_SCHEDULE,
  //   );
  //   var result = await MobMongo.insert(carrier);
  //   pp('$kk FieldMonitorSchedule added to local cache: ${project.projectName}');
  //   return result;
  // }
  // static Future addCommunity(Community community) async {
  //   print('$kk .... addCommunity .....');
  //   await _connectToLocalDB();
  //   Carrier carrier = Carrier(
  //     db: databaseName,
  //     collection: Constants.COMMUNITY,
  //   );
  //   var result = await MobMongo.insert(carrier);
  //   pp('$kk Community added to local cache: ${community.name}');
  //   return result;
  // }
  // static Future addOrganization(Organization organization) async {
  //   print('$kk .... addOrganization .....');
  //   await _connectToLocalDB();
  //   Carrier carrier = Carrier(
  //     db: databaseName,
  //     collection: Constants.ORGANIZATION,
  //   );
  //   var result = await MobMongo.insert(carrier);
  //   pp('$kk Organization added to local cache: ${organization.name}');
  //   return result;
  // }

  @override
  Future<int> addCondition({required Condition condition}) {
    // TODO: implement addCondition
    throw UnimplementedError();
  }

  @override
  Future<int> addFieldMonitorSchedules({required List<FieldMonitorSchedule> schedules}) {
    // TODO: implement addFieldMonitorSchedules
    throw UnimplementedError();
  }

  @override
  Future<int> addOrgMessage({required OrgMessage message}) {
    // TODO: implement addOrgMessage
    throw UnimplementedError();
  }

  @override
  Future<int> addPhotos({required List<Photo> photos}) {
    // TODO: implement addPhotos
    throw UnimplementedError();
  }

  @override
  Future<int> addProjectPositions({required List<ProjectPosition> positions}) {
    // TODO: implement addProjectPositions
    throw UnimplementedError();
  }

  @override
  Future<int> addProjects({required List<Project> projects}) {
    // TODO: implement addProjects
    throw UnimplementedError();
  }

  @override
  Future<int> addUsers({required List<User> users}) {
    // TODO: implement addUsers
    throw UnimplementedError();
  }

  @override
  Future<int> addVideos({required List<Video> videos}) {
    // TODO: implement addVideos
    throw UnimplementedError();
  }

  @override
  List<FieldMonitorSchedule> filterSchedulesByProject(List<FieldMonitorSchedule> mList) {
    // TODO: implement filterSchedulesByProject
    throw UnimplementedError();
  }

  @override
  Future<List<MonitorReport>> findMonitorReportsByLocation({required latitude, required longitude, required radiusInKM}) {
    // TODO: implement findMonitorReportsByLocation
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> findPhotosByLocation({required latitude, required longitude, required radiusInKM}) {
    // TODO: implement findPhotosByLocation
    throw UnimplementedError();
  }

  @override
  Future<List<ProjectPosition>> findProjectPositionsByLocation({required latitude, required longitude, required radiusInKM}) {
    // TODO: implement findProjectPositionsByLocation
    throw UnimplementedError();
  }

  @override
  Future<List<Project>> findProjectsByLocation({required latitude, required longitude, required radiusInKM}) {
    // TODO: implement findProjectsByLocation
    throw UnimplementedError();
  }

  @override
  Future<List<Video>> findVideosByLocation({required latitude, required longitude, required radiusInKM}) {
    // TODO: implement findVideosByLocation
    throw UnimplementedError();
  }

  @override
  Future<List<FieldMonitorSchedule>> getFieldMonitorSchedules(String userId) {
    // TODO: implement getFieldMonitorSchedules
    throw UnimplementedError();
  }

  @override
  Future<List<FieldMonitorSchedule>> getOrganizationMonitorSchedules(String organizationId) {
    // TODO: implement getOrganizationMonitorSchedules
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getPhotos() {
    // TODO: implement getPhotos
    throw UnimplementedError();
  }

  @override
  Future<List<FieldMonitorSchedule>> getProjectMonitorSchedules(String projectId) {
    // TODO: implement getProjectMonitorSchedules
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getProjectPhotos(String projectId) {
    // TODO: implement getProjectPhotos
    throw UnimplementedError();
  }

  @override
  Future<List<Video>> getProjectVideos(String projectId) {
    // TODO: implement getProjectVideos
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getUserPhotos(String userId) {
    // TODO: implement getUserPhotos
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<List<Video>> getVideos() {
    // TODO: implement getVideos
    throw UnimplementedError();
  }

  @override
  Future<int> addFieldMonitorSchedule({required FieldMonitorSchedule schedule}) {
    // TODO: implement addFieldMonitorSchedule
    throw UnimplementedError();
  }

  @override
  Future<int> addPhoto({required Photo photo}) async {
    print('$kk .... addPhoto .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.PHOTO,
      );
      var result = await MobMongo.insert(carrier);
      pp('$kk Photo added to local cache: ${photo.projectName}');
      return result;
  }

  @override
  Future<int> addProject({required Project project}) async {
      print('$kk .... addProject .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.PROJECT,
      );
      var result = await MobMongo.insert(carrier);
      pp('$kk Project added to local cache: ${project.name}');
      return result;
  }

  @override
  Future<int> addProjectPosition({required ProjectPosition projectPosition}) async {
      print('$kk .... addProjectPosition .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.PROJECT_POSITION,
      );
      var result = await MobMongo.insert(carrier);
      pp('$kk ProjectPosition added to local cache: ${projectPosition.projectName}');
      return result;
  }

  @override
  Future<int> addUser({required User user}) async{
      print('$kk .... addProjectPosition .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.USER,
      );
      var result = await MobMongo.insert(carrier);
      pp('$kk User added to local cache: ${user.name}');
      return result;
  }

  @override
  Future<int> addVideo({required Video video}) async {
    print('$kk .... addVideo .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.VIDEO,
    );
    var result = await MobMongo.insert(carrier);
    pp('$kk Video added to local cache: ${video.projectName}');
    return result;
  }

  @override
  Future<List<Project>> getProjects() async {
      print('$kk .... getProjects .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.PROJECT,
      );
      List result = await (MobMongo.getAll(carrier));
      List<Project> projects = [];
      result.forEach((r) {
        projects.add(Project.fromJson(json.decode(r)));
      });
      return projects;
  }

  @override
  Future<int> addCities({required List<City> cities}) async {
    for (var city in cities) {
      await addCity(city: city);
    }
    return 0;
  }

  @override
  Future<int> addCity({required City city}) async {
      print('$kk .... addCity .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.CITY,
      );
      var result = await MobMongo.insert(carrier);
      pp('$kk City added to local cache: ${city.name}');
      return result;
  }

  @override
  Future<int> addMonitorReport({required MonitorReport monitorReport}) async {
    print('$kk .... addMonitorReport .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.MONITOR_REPORT,
    );
    var result = await MobMongo.insert(carrier);
    pp('$kk MonitorReport added to local cache: ${monitorReport.projectId}');
    return result;
  }

  @override
  Future<int> addMonitorReports({required List<MonitorReport> monitorReports}) async {
    for (var r in monitorReports) {
      await addMonitorReport(monitorReport: r);
    }
    return 0;
  }

  @override
  Future<int> addCommunities({required List<Community> communities}) async {
    for (var c in communities) {
      await addCommunity(community: c);
    }
    return 0;
  }

  @override
  Future<int> addCommunity({required Community community}) async {
    print('$kk .... addCommunity .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.COMMUNITY,
    );
    var result = await MobMongo.insert(carrier);
    pp('$kk Community added to local cache: ${community.name}');
    return result;
  }

  @override
  Future<int> addOrganization({required Organization organization}) {
    // TODO: implement addOrganization
    throw UnimplementedError();
  }

  @override
  Future<List<City>> findCitiesByLocation({required latitude, required longitude, required radiusInKM}) {
    // TODO: implement findCitiesByLocation
    throw UnimplementedError();
  }

  @override
  Future<List<Community>> getCommunities() {
    // TODO: implement getCommunities
    throw UnimplementedError();
  }

  @override
  Future<List<Organization>> getOrganizations() {
    // TODO: implement getOrganizations
    throw UnimplementedError();
  }
}