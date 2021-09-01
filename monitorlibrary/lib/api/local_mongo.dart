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
import 'package:monitorlibrary/data/section.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';

import '../constants.dart';
import 'cache.dart';
final LocalMongo localMongo = LocalMongo();
class LocalMongo implements LocalDatabase {
  static const APP_ID = 'arAppID';
  bool dbConnected = false;
  static int cnt = 0;
  static const mm = '🌼🌼 🌼🌼 🌼🌼 LocalMongo: 🌼🌼 ';
  String databaseName = 'ARDB001b';


  LocalMongo() {
    pp('\n\n$mm 🍎 🍎 🍎  setting up MongoDB Mobile ... 🍎 🍎 🍎 ');
    _connectToLocalDB();
  }
  

  Future _setAppID() async {
    pp('🍎 🍎 🍎 setting MongoDB Mobile appID  ... 🍎 🍎 🍎 ');
    try {
      var res = await MobMongo.setAppID({
        'appID': APP_ID,
        'type': MobMongo.LOCAL_DATABASE,
      });
      pp('$mm result of MobMongo.setAppID:  $res');
    } on PlatformException catch (f) {
      pp('👿👿👿👿👿👿👿👿 PlatformException 🍎 🍎 🍎 - $f');
      throw Exception(f.message);
    }
  }

  Future _connectToLocalDB() async {
    if (dbConnected) {
      return null;
    }
    pp('$mm .... Connecting to MongoDB Mobile ... 🔵 🔵 🔵 🔵 🔵 🔵 🔵 ');
    try {
      pp('$mm 🧩 🧩 🧩_connectToLocalDB: will create indexes ......');
      _setAppID();
      await _createIndices();
      dbConnected = true;
      pp('$mm 👌 Connected to MongoDB Mobile. 🥬 DATABASE: $databaseName  🥬 APP_ID: $APP_ID  👌 👌 👌 '
          ' necessary indices created for routes and landmarks 🧩 🧩 🧩');
    } on PlatformException catch (e) {
      pp('👿👿👿👿👿👿👿👿👿👿 ${e.message}  👿👿👿👿');
      throw Exception(e);
    }
  }

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
  

  @override
  Future<int> addCondition({required Condition condition}) async {
    pp('$mm .... addCondition .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.CONDITION,
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Condition added to local cache: ${condition.projectName}');
    return result;
  }

  @override
  Future<int> addFieldMonitorSchedules({required List<FieldMonitorSchedule> schedules}) async {
    for (var s in schedules) {
      await addFieldMonitorSchedule(schedule: s);
    }
    return 0;
  }

  @override
  Future<int> addOrgMessage({required OrgMessage message}) async {
    pp('$mm .... addOrgMessage .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.ORG_MESSAGE,
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm OrgMessage added to local cache: ${message.projectName}');
    return result;
  }

  @override
  Future<int> addPhotos({required List<Photo> photos}) async {
    for (var v in photos) {
      await addPhoto(photo: v);
    }
    return 0;
  }

  @override
  Future<int> addProjectPositions({required List<ProjectPosition> positions}) async {
    for (var v in positions) {
      await addProjectPosition(projectPosition: v);
    }
    return 0;
  }

  @override
  Future<int> addProjects({required List<Project> projects}) async {
    for (var v in projects) {
      await addProject(project: v);
    }
    return 0;
  }

  @override
  Future<int> addUsers({required List<User> users}) async {
    for (var v in users) {
      await addUser(user: v);
    }
    return 0;
  }

  @override
  Future<int> addVideos({required List<Video> videos}) async {
    for (var v in videos) {
      await addVideo(video: v);
    }
    return 0;
  }

  @override
  List<FieldMonitorSchedule> filterSchedulesByProject(List<FieldMonitorSchedule> mList, String projectId) {
    List<FieldMonitorSchedule> list = [];
    mList.forEach((element) { 
      if (element.projectId == projectId) {
        list.add(element);
      }
    });
    return list;
  }

  @override
  Future<List<MonitorReport>> findMonitorReportsByLocation({required latitude, required longitude, required radiusInKM}) async {
    var radius = radiusInKM * 1000;
    Carrier carrier =
    Carrier(db: databaseName, collection: Constants.MONITOR_REPORT, query: {
      "eq": {
        'position': {
          "\$near": {
            "\$geometry": {
              "coordinates": [longitude, latitude],
              "type": "Point",
            },
            "\$maxDistance": radius,
          },
        },
      }
    });
    var result = await MobMongo.query(carrier);
    List<MonitorReport> list = [];
    result.forEach((m) {
      list.add(MonitorReport.fromJson(json.decode(m)));
    });
    return list;
  }

  @override
  Future<List<Photo>> findPhotosByLocation({required latitude, required longitude, required radiusInKM}) async {
    var radius = radiusInKM * 1000;
    Carrier carrier =
    Carrier(db: databaseName, collection: Constants.PHOTO, query: {
      "eq": {
        'position': {
          "\$near": {
            "\$geometry": {
              "coordinates": [longitude, latitude],
              "type": "Point",
            },
            "\$maxDistance": radius,
          },
        },
      }
    });
    var result = await MobMongo.query(carrier);
    List<Photo> list = [];
    result.forEach((m) {
      list.add(Photo.fromJson(json.decode(m)));
    });
    return list;
  }

  @override
  Future<List<ProjectPosition>> findProjectPositionsByLocation({required latitude, required longitude, required radiusInKM}) async {
    var radius = radiusInKM * 1000;
    Carrier carrier =
    Carrier(db: databaseName, collection: Constants.PROJECT_POSITION, query: {
      "eq": {
        'position': {
          "\$near": {
            "\$geometry": {
              "coordinates": [longitude, latitude],
              "type": "Point",
            },
            "\$maxDistance": radius,
          },
        },
      }
    });
    var result = await MobMongo.query(carrier);
    List<ProjectPosition> list = [];
    result.forEach((m) {
      list.add(ProjectPosition.fromJson(json.decode(m)));
    });
    return list;
  }

  @override
  Future<List<Project>> findProjectsByLocation({required latitude, required longitude, required radiusInKM}) async {
    var radius = radiusInKM * 1000;
    Carrier carrier =
    Carrier(db: databaseName, collection: Constants.PROJECT, query: {
      "eq": {
        'position': {
          "\$near": {
            "\$geometry": {
              "coordinates": [longitude, latitude],
              "type": "Point",
            },
            "\$maxDistance": radius,
          },
        },
      }
    });
    var result = await MobMongo.query(carrier);
    List<Project> list = [];
    result.forEach((m) {
      list.add(Project.fromJson(json.decode(m)));
    });
    return list;
  }

  @override
  Future<List<Video>> findVideosByLocation({required latitude, required longitude, required radiusInKM}) async {
    var radius = radiusInKM * 1000;
    Carrier carrier =
    Carrier(db: databaseName, collection: Constants.VIDEO, query: {
      "eq": {
        'position': {
          "\$near": {
            "\$geometry": {
              "coordinates": [longitude, latitude],
              "type": "Point",
            },
            "\$maxDistance": radius,
          },
        },
      }
    });
    var result = await MobMongo.query(carrier);
    List<Video> list = [];
    result.forEach((m) {
      list.add(Video.fromJson(json.decode(m)));
    });
    return list;
  }

  @override
  Future<List<FieldMonitorSchedule>> getFieldMonitorSchedules(String userId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<FieldMonitorSchedule>> getOrganizationMonitorSchedules(String organizationId) async {
    pp('$mm .... getProjectMonitorSchedules .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.FIELD_MONITOR_SCHEDULE,
    );
    List result = await (MobMongo.getAll(carrier));
    List<FieldMonitorSchedule> schedules = [];
    result.forEach((r) {
      var x = FieldMonitorSchedule.fromJson(json.decode(r));
      if (x.organizationId == organizationId) {
        schedules.add(r);
      }
    });
    return schedules;
  }

  @override
  Future<List<Photo>> getPhotos() {
    // TODO: implement getPhotos
    throw UnimplementedError();
  }

  @override
  Future<List<FieldMonitorSchedule>> getProjectMonitorSchedules(String projectId) async {
    pp('$mm .... getProjectMonitorSchedules .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.FIELD_MONITOR_SCHEDULE,
    );
    List result = await (MobMongo.getAll(carrier));
    List<FieldMonitorSchedule> schedules = [];
    result.forEach((r) {
      var x = FieldMonitorSchedule.fromJson(json.decode(r));
      if (x.projectId == projectId) {
        schedules.add(r);
      }
    });
    return schedules;
  }

  @override
  Future<List<Photo>> getProjectPhotos(String projectId) async {
    var list = await getPhotos();
    List<Photo> mList = [];
    list.forEach((element) {
      if (element.projectId == projectId) {
        mList.add(element);
      }
    });
    return mList;
  }

  @override
  Future<List<Video>> getProjectVideos(String projectId) async {
    var list = await getVideos();
    List<Video> mList = [];
    list.forEach((element) { 
      if (element.projectId == projectId) {
        mList.add(element);
      }
    });
    return mList;
  }

  @override
  Future<List<Photo>> getUserPhotos(String userId) async{
    var list = await getPhotos();
    List<Photo> mList = [];
    list.forEach((element) {
      if (element.userId == userId) {
        mList.add(element);
      }
    });
    return mList;
  }

  @override
  Future<List<User>> getUsers() async {
    pp('$mm .... getUsers .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.USER,
    );
    List result = await (MobMongo.getAll(carrier));
    List<User> users = [];
    result.forEach((r) {
      users.add(User.fromJson(json.decode(r)));
    });
    return users;
  }

  @override
  Future<List<Video>> getVideos() async {
    pp('$mm .... getUsers .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.VIDEO,
    );
    List result = await (MobMongo.getAll(carrier));
    List<Video> videos = [];
    result.forEach((r) {
      videos.add(Video.fromJson(json.decode(r)));
    });
    return videos;
  }

  @override
  Future<int> addFieldMonitorSchedule({required FieldMonitorSchedule schedule}) async  {
    pp('$mm .... addFieldMonitorSchedule .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.FIELD_MONITOR_SCHEDULE,
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm FieldMonitorSchedule added to local cache: ${schedule.projectName}');
    return result;
  }

  @override
  Future<int> addPhoto({required Photo photo}) async {
    pp('$mm .... addPhoto .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.PHOTO,
      );
      var result = await MobMongo.insert(carrier);
      pp('$mm Photo added to local cache: ${photo.projectName}');
      return result;
  }

  @override
  Future<int> addProject({required Project project}) async {
      pp('$mm .... addProject .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.PROJECT,
      );
      var result = await MobMongo.insert(carrier);
      pp('$mm Project added to local cache: ${project.name}');
      return result;
  }

  @override
  Future<int> addProjectPosition({required ProjectPosition projectPosition}) async {
      pp('$mm .... addProjectPosition .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.PROJECT_POSITION,
      );
      var result = await MobMongo.insert(carrier);
      pp('$mm ProjectPosition added to local cache: ${projectPosition.projectName}');
      return result;
  }

  @override
  Future<int> addUser({required User user}) async{
      pp('$mm .... addProjectPosition .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.USER,
      );
      var result = await MobMongo.insert(carrier);
      pp('$mm User added to local cache: ${user.name}');
      return result;
  }

  @override
  Future<int> addVideo({required Video video}) async {
    pp('$mm .... addVideo .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.VIDEO,
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Video added to local cache: ${video.projectName}');
    return result;
  }

  @override
  Future<List<Project>> getProjects() async {
      pp('$mm .... getProjects .....');
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
      pp('$mm .... addCity .....');
      Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.CITY,
      );
      var result = await MobMongo.insert(carrier);
      pp('$mm City added to local cache: ${city.name}');
      return result;
  }

  @override
  Future<int> addMonitorReport({required MonitorReport monitorReport}) async {
    pp('$mm .... addMonitorReport .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.MONITOR_REPORT,
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm MonitorReport added to local cache: ${monitorReport.projectId}');
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
    pp('$mm .... addCommunity .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.COMMUNITY,
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Community added to local cache: ${community.name}');
    return result;
  }

  @override
  Future<int> addOrganization({required Organization organization}) async {
    pp('$mm .... addCommunity .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.ORGANIZATION,
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Community added to local cache: ${organization.name}');
    return result;
  }

  @override
  Future<List<City>> findCitiesByLocation({required latitude, required longitude, required radiusInKM}) {
    // TODO: implement findCitiesByLocation
    throw UnimplementedError();
  }

  @override
  Future<List<Community>> getCommunities() async {
    pp('$mm .... getCommunities .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.COMMUNITY,
    );
    List result = await (MobMongo.getAll(carrier));
    List<Community> comms = [];
    result.forEach((r) {
      comms.add(Community.fromJson(json.decode(r)));
    });
    return comms;
  }

  @override
  Future<List<Organization>> getOrganizations() async {
    pp('$mm .... getProjects .....');
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.ORGANIZATION,
    );
    List result = await (MobMongo.getAll(carrier));
    List<Organization> orgs = [];
    result.forEach((r) {
      orgs.add(Organization.fromJson(json.decode(r)));
    });
    return orgs;
  }

  @override
  Future<int> addSection({required Section section}) {
    // TODO: implement addSection
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getSections(String questionnaireId) {
    // TODO: implement getSections
    throw UnimplementedError();
  }
}