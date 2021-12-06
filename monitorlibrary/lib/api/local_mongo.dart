import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobmongo/carrier.dart';
import 'package:mobmongo/mobmongo3.dart';
import 'package:monitorlibrary/data/city.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/field_monitor_schedule.dart';
import 'package:monitorlibrary/data/geofence_event.dart';
import 'package:monitorlibrary/data/monitor_report.dart';
import 'package:monitorlibrary/data/organization.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/data/section.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import '../constants.dart';

class LocalMongo {
  static const APP_ID = 'monAppID1';
  static bool dbConnected = false;
  static int cnt = 0;
  static const mm = '🌼🌼 🌼🌼 🌼🌼 LocalMongo: 🌼🌼 ';
  static String databaseName = 'monDB001b';

  static Future _connectToLocalDB() async {
    if (dbConnected) {
      return null;
    }
    pp('$mm .... Connecting to MongoDB Mobile ... 🔵 🔵 🔵 🔵 🔵 🔵 🔵 ');
    try {
      pp('$mm 🧩 🧩 🧩_connectToLocalDB: will create indexes ......');
      await _createIndices();
      dbConnected = true;
      pp('$mm 👌 Connected to MongoDB Mobile. 🥬 DATABASE: $databaseName  🥬 APP_ID: $APP_ID  👌 👌 👌 '
          ' necessary indices created for routes and landmarks 🧩 🧩 🧩');
    } on PlatformException catch (e) {
      pp('👿👿👿👿👿👿👿👿👿👿 ${e.message}  👿👿👿👿');
      throw Exception(e);
    }
  }

  static Future _createIndices() async {
    pp('$mm ................ _createIndices .....');
    try {
      var carr1 = Carrier(
          db: databaseName, collection: Constants.CITY, index: {"cityId": 1});
      await MobMongo.createIndex(carr1);
      var carr1b = Carrier(
          db: databaseName,
          collection: Constants.CITY,
          index: {"countryId": 1});
      await MobMongo.createIndex(carr1b);
      var carr1a = Carrier(
          db: databaseName,
          collection: Constants.CITY,
          index: {"position": "2dsphere"});
      await MobMongo.createIndex(carr1a);
      pp('$mm city indexes added');

      var carr3 = Carrier(
          db: databaseName,
          collection: Constants.PROJECT,
          index: {"position": "2dsphere"});
      await MobMongo.createIndex(carr3);
      var carr3a = Carrier(
          db: databaseName,
          collection: Constants.PROJECT,
          index: {"projectId": 1});
      await MobMongo.createIndex(carr3a);
      var carr3b = Carrier(
          db: databaseName,
          collection: Constants.PROJECT,
          index: {"organizationId": 1});
      await MobMongo.createIndex(carr3b);
      pp('$mm project indexes added');

      var carr4 = Carrier(
          db: databaseName,
          collection: Constants.PROJECT_POSITION,
          index: {"position": "2dsphere"});
      await MobMongo.createIndex(carr4);
      var carr4a = Carrier(
          db: databaseName,
          collection: Constants.PROJECT_POSITION,
          index: {"projectId": 1});
      await MobMongo.createIndex(carr4a);
      pp('$mm projectPosition indexes added');

      // var carr12 = Carrier(
      //     db: databaseName,
      //     collection: Constants.GEOFENCE_EVENT,
      //     index: {"position": "2dsphere"});
      // await MobMongo.createIndex(carr12);
      var carr12a = Carrier(
          db: databaseName,
          collection: Constants.GEOFENCE_EVENT,
          index: {"projectPositionId": 1});
      await MobMongo.createIndex(carr12a);
      var carr12b = Carrier(
          db: databaseName,
          collection: Constants.GEOFENCE_EVENT,
          index: {"userId": 1});
      await MobMongo.createIndex(carr12b);
      pp('$mm geofenceEvent indexes added');

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
      var carr6a = Carrier(
          db: databaseName, collection: Constants.PHOTO, index: {"userId": 1});
      await MobMongo.createIndex(carr6a);
      pp('$mm photo indexes added');

      var carr7 = Carrier(
          db: databaseName,
          collection: Constants.VIDEO,
          index: {"projectId": 1});
      await MobMongo.createIndex(carr7);
      var carr7a = Carrier(
          db: databaseName, collection: Constants.VIDEO, index: {"userId": 1});
      await MobMongo.createIndex(carr7a);
      var carr8 = Carrier(
          db: databaseName,
          collection: Constants.VIDEO,
          index: {"position": "2dsphere"});
      await MobMongo.createIndex(carr8);
      pp('$mm video indexes added');

      var carr9 = Carrier(
          db: databaseName,
          collection: Constants.MONITOR_REPORT,
          index: {"projectId": 1});
      await MobMongo.createIndex(carr9);
      var carr9a = Carrier(
          db: databaseName,
          collection: Constants.MONITOR_REPORT,
          index: {"userId": 1});
      await MobMongo.createIndex(carr9a);
      var carr10 = Carrier(
          db: databaseName,
          collection: Constants.MONITOR_REPORT,
          index: {"position": "2dsphere"});
      await MobMongo.createIndex(carr10);
      pp('$mm monitorReport indexes added');

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
          index: {"fieldMonitorId": 1});
      await MobMongo.createIndex(carr13);
      pp('$mm fieldMonitorSchedule indexes added');

      pp('$mm 🧩 🧩 🧩 🧩 🧩 🧩 ALL local MongoDB indices built! - 👌 👌 👌');
    } catch (e) {
      pp('$mm 👿👿👿👿 '
          'Fell down creating local mongo indexes: '
          '👿👿👿👿 $e');
    }
  }

  static Future addCondition({required Condition condition}) async {
    pp('$mm .... addCondition .....');
    await delete(
        field: 'conditionId',
        id: condition.conditionId!,
        collectionName: Constants.CONDITION);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.CONDITION,
      data: condition.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Condition added to local cache: ${condition.projectName}');
    return result;
  }

  static Future addFieldMonitorSchedules(
      {required List<FieldMonitorSchedule> schedules}) async {
    for (var s in schedules) {
      await addFieldMonitorSchedule(schedule: s);
    }
    return 0;
  }

  static Future addOrgMessage({required OrgMessage message}) async {
    pp('$mm .... addOrgMessage .....');
    await delete(
        field: 'orgMessageId',
        id: message.orgMessageId!,
        collectionName: Constants.ORG_MESSAGE);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.ORG_MESSAGE,
      data: message.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm OrgMessage added to local cache: ${message.projectName}');
    return result;
  }

  static Future addPhotos({required List<Photo> photos}) async {
    for (var v in photos) {
      await addPhoto(photo: v);
    }
    return photos.length;
  }

  static Future addProjectPositions(
      {required List<ProjectPosition> positions}) async {
    for (var v in positions) {
      await addProjectPosition(projectPosition: v);
    }
    return positions.length;
  }

  static Future addProjects({required List<Project> projects}) async {
    for (var v in projects) {
      await addProject(project: v);
    }
    return projects.length;
  }

  static Future addUsers({required List<User> users}) async {
    pp('$mm adding ${users.length} users to local cache ...');
    for (var v in users) {
      await addUser(user: v);
    }
    return users.length;
  }

  static Future addVideos({required List<Video> videos}) async {
    for (var v in videos) {
      await addVideo(video: v);
    }
    return videos.length;
  }

  List<FieldMonitorSchedule> filterSchedulesByProject(
      List<FieldMonitorSchedule> mList, String projectId) {
    List<FieldMonitorSchedule> list = [];
    mList.forEach((element) {
      if (element.projectId == projectId) {
        list.add(element);
      }
    });
    return list;
  }

  static Future<List<MonitorReport>> findMonitorReportsByLocation(
      {required latitude, required longitude, required radiusInKM}) async {
    await _connectToLocalDB();
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

  static Future<List<Photo>> findPhotosByLocation(
      {required latitude, required longitude, required radiusInKM}) async {
    await _connectToLocalDB();
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

  static Future<List<ProjectPosition>> findProjectPositionsByLocation(
      {required latitude, required longitude, required radiusInKM}) async {
    await _connectToLocalDB();
    var radius = radiusInKM * 1000;
    Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.PROJECT_POSITION,
        query: {
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

  static Future<Project?> getProjectById({required String projectId}) async {
    await _connectToLocalDB();
    Carrier carrier =
        Carrier(db: databaseName, collection: Constants.PROJECT, query: {
      "eq": {'projectId': projectId}
    });
    var result = await MobMongo.query(carrier);
    List<Project> list = [];
    result.forEach((m) {
      list.add(Project.fromJson(json.decode(m)));
    });
    if (list.isNotEmpty) {
      return list.first;
    } else {
      return null;
    }
  }

  static Future<List<Project>> findProjectsByLocation(
      {required double latitude,
      required double longitude,
      required double radiusInKM}) async {
    await _connectToLocalDB();
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

  static Future<List<Video>> findVideosByLocation(
      {required latitude, required longitude, required radiusInKM}) async {
    await _connectToLocalDB();
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

  static Future<List<FieldMonitorSchedule>> getFieldMonitorSchedules(
      String userId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.FIELD_MONITOR_SCHEDULE,
    );
    List result = await (MobMongo.getAll(carrier));
    List<FieldMonitorSchedule> schedules = [];
    result.forEach((r) {
      var x = FieldMonitorSchedule.fromJson(json.decode(r));
      if (x.fieldMonitorId == userId) {
        schedules.add(x);
      }
    });
    return schedules;
  }

  static Future<List<FieldMonitorSchedule>> getOrganizationMonitorSchedules(
      String organizationId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.FIELD_MONITOR_SCHEDULE,
    );
    List result = await (MobMongo.getAll(carrier));
    List<FieldMonitorSchedule> schedules = [];
    result.forEach((r) {
      var x = FieldMonitorSchedule.fromJson(json.decode(r));
      if (x.organizationId == organizationId) {
        schedules.add(x);
      }
    });
    return schedules;
  }

  static Future<List<GeofenceEvent>> getGeofenceEventsByUser(
      String userId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.GEOFENCE_EVENT,
    );
    List result = await (MobMongo.getAll(carrier));
    List<GeofenceEvent> events = [];
    result.forEach((r) {
      var x = GeofenceEvent.fromJson(json.decode(r));
      if (x.userId == userId) {
        events.add(x);
      }
    });
    return events;
  }
  static Future<List<GeofenceEvent>> getGeofenceEventsByProjectPosition(
      String projectPositionId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.GEOFENCE_EVENT,
    );
    List result = await (MobMongo.getAll(carrier));
    List<GeofenceEvent> events = [];
    result.forEach((r) {
      var x = GeofenceEvent.fromJson(json.decode(r));
      if (x.projectPositionId == projectPositionId) {
        events.add(x);
      }
    });
    return events;
  }

  static Future<List<Photo>> getPhotos() async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.PHOTO,
    );
    List result = await (MobMongo.getAll(carrier));
    List<Photo> schedules = [];
    result.forEach((r) {
      var x = Photo.fromJson(json.decode(r));
      schedules.add(x);
    });
    return schedules;
  }

  static Future<List<FieldMonitorSchedule>> getProjectMonitorSchedules(
      String projectId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.FIELD_MONITOR_SCHEDULE,
    );
    List result = await (MobMongo.getAll(carrier));
    List<FieldMonitorSchedule> schedules = [];
    result.forEach((r) {
      var x = FieldMonitorSchedule.fromJson(json.decode(r));
      if (x.projectId == projectId) {
        schedules.add(x);
      }
    });
    return schedules;
  }

  static Future<List<Photo>> getProjectPhotos(String projectId) async {
    var list = await getPhotos();
    List<Photo> mList = [];
    list.forEach((element) {
      if (element.projectId == projectId) {
        mList.add(element);
      }
    });
    return mList;
  }

  static Future<List<Video>> getProjectVideos(String projectId) async {
    var list = await getVideos();
    List<Video> mList = [];
    list.forEach((element) {
      if (element.projectId == projectId) {
        mList.add(element);
      }
    });
    return mList;
  }

  static Future<List<Photo>> getUserPhotos(String userId) async {
    var list = await getPhotos();
    List<Photo> mList = [];
    list.forEach((element) {
      if (element.userId == userId) {
        mList.add(element);
      }
    });
    return mList;
  }

  static Future<List<User>> getUsers() async {
    await _connectToLocalDB();
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

  static Future<List<Video>> getVideos() async {
    await _connectToLocalDB();
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

  static Future addFieldMonitorSchedule(
      {required FieldMonitorSchedule schedule}) async {
    pp('$mm .... addFieldMonitorSchedule .....');
    await delete(
        field: 'fieldMonitorScheduleId',
        id: schedule.fieldMonitorScheduleId!,
        collectionName: Constants.FIELD_MONITOR_SCHEDULE);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.FIELD_MONITOR_SCHEDULE,
      data: schedule.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm FieldMonitorSchedule added to local cache:  🔵 🔵 ${schedule.projectName}');
    return result;
  }

  static Future addPhoto({required Photo photo}) async {
    await delete(
        field: 'photoId', id: photo.photoId!, collectionName: Constants.PHOTO);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.PHOTO,
      data: photo.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Photo added to local cache:  🔵 🔵 ${photo.projectName}');
    return result;
  }

  static Future addProject({required Project project}) async {
    await delete(
        field: 'projectId',
        id: project.projectId!,
        collectionName: Constants.PROJECT);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.PROJECT,
      data: project.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Project added to local cache:  🔵 🔵 ${project.name} result of call: $result');
    return result;
  }

  static Future addProjectPosition(
      {required ProjectPosition projectPosition}) async {
    await delete(
        field: 'projectPositionId',
        id: projectPosition.projectPositionId!,
        collectionName: Constants.PROJECT_POSITION);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.PROJECT_POSITION,
      data: projectPosition.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm ProjectPosition added to local cache:  🔵 🔵 ${projectPosition.projectName} organizationId: ${projectPosition.organizationId} ');
    return result;
  }

  static Future addUser({required User user}) async {
    await _connectToLocalDB();
    await delete(
        field: 'userId', id: user.userId!, collectionName: Constants.USER);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.USER,
      data: user.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm User added to local cache: 🔵 🔵  ${user.name} mongo result result: $result');
    return result;
  }

  static Future addVideo({required Video video}) async {
    await delete(
        field: 'videoId', id: video.videoId!, collectionName: Constants.VIDEO);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.VIDEO,
      data: video.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Video added to local cache:  🔵 🔵 ${video.projectName}');
    return result;
  }

  static Future<List<Project>> getProjects(String organizationId) async {
    pp('$mm .... getProjects ..... organizationId: $organizationId');
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.PROJECT,
    );
    List result = await (MobMongo.getAll(carrier));
    List<Project> projects = [];
    result.forEach((r) {
      var p = Project.fromJson(json.decode(r));
      if (p.organizationId == organizationId) {
        projects.add(p);
      }
    });
    pp('$mm .... getProjects ..... found:  🌼 ${projects.length}  🌼');
    return projects;
  }

  static Future addCities({required List<City> cities}) async {
    for (var city in cities) {
      await addCity(city: city);
    }
    return 0;
  }

  static Future addCity({required City city}) async {
    await delete(
        field: 'cityId', id: city.cityId!, collectionName: Constants.CITY);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.CITY,
      data: city.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm City added to local cache: 🌿 ${city.name}');
    return result;
  }

  static Future addMonitorReport({required MonitorReport monitorReport}) async {
    await delete(
        field: 'monitorReportId',
        id: monitorReport.monitorReportId!,
        collectionName: Constants.MONITOR_REPORT);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.MONITOR_REPORT,
      data: monitorReport.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm MonitorReport added to local cache: 🌿 ${monitorReport.projectId}');
    return result;
  }

  static Future addMonitorReports(
      {required List<MonitorReport> monitorReports}) async {
    for (var r in monitorReports) {
      await addMonitorReport(monitorReport: r);
    }
    return 0;
  }

  static Future addCommunities({required List<Community> communities}) async {
    for (var c in communities) {
      await addCommunity(community: c);
    }
    return 0;
  }
  static Future addGeofenceEvent({required GeofenceEvent geofenceEvent}) async {
    await delete(
        field: 'geofenceEventId',
        id: geofenceEvent.geofenceEventId!,
        collectionName: Constants.GEOFENCE_EVENT);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.GEOFENCE_EVENT,
      data: geofenceEvent.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm GeofenceEvent added to local cache: ${geofenceEvent.projectName}');
    return result;
  }
  static Future addCommunity({required Community community}) async {
    await delete(
        field: 'communityId',
        id: community.communityId!,
        collectionName: Constants.COMMUNITY);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.COMMUNITY,
      data: community.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Community added to local cache: ${community.name}');
    return result;
  }

  static Future addOrganization({required Organization organization}) async {
    await delete(
        field: 'organizationId',
        id: organization.organizationId!,
        collectionName: Constants.ORGANIZATION);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.ORGANIZATION,
      data: organization.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm Organization added to local cache: ${organization.name}');
    return result;
  }

  static Future<List<City>> findCitiesByLocation(
      {required latitude, required longitude, required radiusInKM}) {
    // TODO: implement findCitiesByLocation
    throw UnimplementedError();
  }

  static Future<List<Community>> getCommunities() async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.COMMUNITY,
    );
    List result = await (MobMongo.getAll(carrier));
    List<Community> comms = [];
    result.forEach((r) {
      comms.add(Community.fromJson(json.decode(r)));
    });
    pp('$mm .... getCommunities ..... found:  🌼 ${comms.length}  🌼');
    return comms;
  }

  static Future<List<Organization>> getOrganizations() async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.ORGANIZATION,
    );
    List result = await (MobMongo.getAll(carrier));
    List<Organization> orgs = [];
    result.forEach((r) {
      orgs.add(Organization.fromJson(json.decode(r)));
    });
    pp('$mm .... getOrganizations ..... found:  🌼 ${orgs.length}  🌼');
    return orgs;
  }

  static Future addSection({required Section section}) async {
    await delete(
        field: 'sectionId',
        id: section.sectionId!,
        collectionName: Constants.SECTION);
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.SECTION,
      data: section.toJson(),
    );
    var result = await MobMongo.insert(carrier);
    pp('$mm section added to local cache:  🔵 🔵 sectionNumber: ${section.sectionNumber}');
    return result;
  }

  static Future<List<Photo>> getSections(String questionnaireId) {
    // TODO: implement getSections
    throw UnimplementedError();
  }

  static Future<List<ProjectPosition>> getOrganizationProjectPositions() async {
    pp('$mm .... getOrganizationProjectPositions ..... ');
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.PROJECT_POSITION,
    );
    List result = await (MobMongo.getAll(carrier));
    List<ProjectPosition> positions = [];
    result.forEach((r) {
      var mJson = jsonDecode(r);
      var projPos = ProjectPosition.fromJson(mJson);
      positions.add(projPos);
    });
    pp('$mm .... getOrganizationProjectPositions ..... 🌺 found:  🌼 ${positions.length}  🌼');
    return positions;
  }

  static Future<List<ProjectPosition>> getProjectPositions(
      String projectId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.PROJECT_POSITION,
    );
    List result = await (MobMongo.getAll(carrier));
    List<ProjectPosition> positions = [];
    result.forEach((r) {
      var mJson = jsonDecode(r);
      var projPos = ProjectPosition.fromJson(mJson);
      if (projPos.projectId == projectId) {
        positions.add(projPos);
      }
    });
    pp('$mm .... getProjectPositions ..... 🌺 found:  🌼 ${positions.length}  🌼');
    return positions;
  }


  static Future<ProjectPosition?> getProjectPosition(
      String projectPositionId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.PROJECT_POSITION,
    );
    List result = await (MobMongo.getAll(carrier));
    ProjectPosition? position;
    result.forEach((r) {
      var mJson = jsonDecode(r);
      var projPos = ProjectPosition.fromJson(mJson);
      if (projPos.projectPositionId == projectPositionId) {
        position = projPos;
      }
    });
    pp('$mm .... getProjectPosition ..... 🌺 found:  🌼 ${position == null? 'Not Found' : position!.projectPositionId}  🌼');
    return position;
  }

  static Future<List<ProjectPosition>> getOrganizationProjectPositionsByLocation({required String organizationId, required double  latitude, required double longitude, required double radiusInKM}) async {

    var positions = <ProjectPosition>[];
    var list  = await getProjectPositionsByLocation(latitude: latitude, longitude: longitude, radiusInKM: radiusInKM);
    list.forEach((element) {
      if (element.organizationId == organizationId) {
        positions.add(element);
      }
    });
    return positions;
  }
  static Future<List<ProjectPosition>> getProjectPositionsByLocation({required double  latitude, required double longitude, required double radiusInKM}) async {
    await _connectToLocalDB();
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
    List<ProjectPosition> positions = [];
    List result = await (MobMongo.query(carrier));
    result.forEach((m) {
      positions.add(ProjectPosition.fromJson(json.decode(m)));
    });
    // Map<String?, ProjectPosition> map = Map();
    // result.forEach((element) {
    //   map[element.landmarkID] = element;
    // });
    // positions = map.values.toList();
    pp('$mm .... getProjectPositionsByLocation ..... 🌺 found:  🌼 ${positions.length}  🌼');
    return positions;

  }

  static Future<List<Video>> getUserVideos(String userId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.VIDEO,
    );
    List result = await (MobMongo.getAll(carrier));
    List<Video> videos = [];
    result.forEach((r) {
      var x = Video.fromJson(json.decode(r));
      if (x.projectId == userId) {
        videos.add(r);
      }
    });
    pp('$mm .... getUserVideos ..... found:  🌼 ${videos.length}  🌼');
    return videos;
  }

  static Future delete(
      {required String field,
      required String id,
      required String collectionName}) async {
    await _connectToLocalDB();
    Carrier c = Carrier(db: databaseName, collection: collectionName, id: {
      'field': field,
      'value': id,
    });
    var result = await MobMongo.delete(c);
    return result;
  }
}
