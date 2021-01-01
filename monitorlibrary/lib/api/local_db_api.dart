import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobmongo/carrier.dart';
import 'package:mobmongo/mobmongo.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/data/user.dart';

import '../functions.dart';
import 'Constants.dart';

class LocalDBAPI {
  static const APP_ID = 'monAppID_0';
  static bool dbConnected = false;
  static int cnt = 0;

  static String databaseName = 'MonDB001a';

  static Future setDatabaseName({@required String name}) async {
    pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵 setDatabaseName: $name MongoDB Mobile .. . 🔵 🔵 🔵 🔵 🔵 🔵 🔵 ');
    if (name == null) {
      throw Exception('The database name cannot be null');
    }
    databaseName = name;
  }

  static Future setAppID() async {
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

  static Future _connectToLocalDB() async {
    if (databaseName == null) {
      throw Exception(
          'Please set the database name using setDatabaseName(String name)');
    }
    if (dbConnected) {
      return null;
    }
    pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵 Connecting to MongoDB Mobile .. . 🔵 🔵 🔵 🔵 🔵 🔵 🔵 ');
    try {
      await MobMongo.setAppID({
        'appID': APP_ID,
        'type': MobMongo.LOCAL_DATABASE,
      });

      await _createIndices();

      dbConnected = true;
      pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵  👌 Connected to MongoDB Mobile. 🥬 DATABASE: $databaseName  🥬 APP_ID: $APP_ID  👌 👌 👌 '
          ' necessary indices created for routes and landmarks 🧩 🧩 🧩');
    } on PlatformException catch (e) {
      pp('👿👿👿👿👿👿👿👿👿👿 ${e.message}  👿👿👿👿');
      throw Exception(e);
    }
  }

  static Future _createIndices() async {
    var carr1 = Carrier(
        db: databaseName,
        collection: Constants.DB_ORGANIZATIONS,
        index: {"organizationId": 1});
    await MobMongo.createIndex(carr1);
    var carr3 = Carrier(
        db: databaseName,
        collection: Constants.DB_PROJECTS,
        index: {"projectId": 1});

    await MobMongo.createIndex(carr3);
    var carr4 = Carrier(
        db: databaseName,
        collection: Constants.DB_PHOTOS,
        index: {"projectId": 1});

    await MobMongo.createIndex(carr4);

    var carr5 = Carrier(
        db: databaseName,
        collection: Constants.DB_PHOTOS,
        index: {"projectPosition": "2dsphere"});

    await MobMongo.createIndex(carr5);

    var carr5a = Carrier(
        db: databaseName,
        collection: Constants.DB_VIDEOS,
        index: {"projectPosition": "2dsphere"});

    await MobMongo.createIndex(carr5a);

    var carr6 = Carrier(
        db: databaseName,
        collection: Constants.DB_PROJECTS,
        index: {"position": "2dsphere"});
    await MobMongo.createIndex(carr6);

    var carr7 = Carrier(
        db: databaseName,
        collection: Constants.DB_VIDEOS,
        index: {"projectId": 1});
    await MobMongo.createIndex(carr7);

    pp('LocalDBAPI: 🧩 🧩 🧩  🧩 🧩 🧩 ALL local indices built! - 👌 👌 👌');
  }

  static Future<List<Project>> getProjects() async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.DB_PROJECTS,
    );
    List result = await MobMongo.getAll(carrier);
    List<Project> k = List();
    result.forEach((r) {
      k.add(Project.fromJson(json.decode(r)));
    });
    return k;
  }

  static Future<List<Photo>> getPhotos() async {
    await _connectToLocalDB();
    Carrier carrier =
        Carrier(db: databaseName, collection: Constants.DB_PHOTOS);
    List results = await MobMongo.getAll(carrier);
    List<Photo> list = List();
    results.forEach((r) {
      var mm = Photo.fromJson(json.decode(r));
      list.add(mm);
    });

    pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵 getPhotos: 🦠 ${list.length}');
    return list;
  }

  static Future<List<Video>> getVideos() async {
    await _connectToLocalDB();
    Carrier carrier =
        Carrier(db: databaseName, collection: Constants.DB_VIDEOS);
    List results = await MobMongo.getAll(carrier);
    List<Video> list = List();
    results.forEach((r) {
      var mm = Video.fromJson(json.decode(r));
      list.add(mm);
    });

    pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵 getVideos: 🦠 ${list.length}');
    return list;
  }

  static Future<List<Photo>> getProjectPhotos(String projectId) async {
    await _connectToLocalDB();
    Carrier carrier =
        Carrier(db: databaseName, collection: Constants.DB_PHOTOS, query: {
      "eq": {"projectId": projectId}
    });
    List results = await MobMongo.query(carrier);
    List<Photo> list = List();
    results.forEach((r) {
      var mm = Photo.fromJson(json.decode(r));
      if (mm.projectId == projectId) {
        list.add(mm);
      }
    });

    pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵 getProjectPhotos: 🦠 ${list.length}');
    return list;
  }

  static Future<List<Video>> getProjectVideos(String projectId) async {
    await _connectToLocalDB();
    Carrier carrier =
        Carrier(db: databaseName, collection: Constants.DB_VIDEOS, query: {
      "eq": {"projectId": projectId}
    });
    List results = await MobMongo.query(carrier);
    List<Video> list = List();
    results.forEach((r) {
      var mm = Video.fromJson(json.decode(r));
      if (mm.projectId == projectId) {
        list.add(mm);
      }
    });

    pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵 getProjectVideos: 🦠 ${list.length}');
    return list;
  }

  static Future<List<ProjectPosition>> getProjectPositions(
      String projectId) async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.DB_PROJECT_POSITIONS,
        query: {
          "eq": {"projectId": projectId}
        });
    List results = await MobMongo.query(carrier);
    List<ProjectPosition> list = List();
    results.forEach((r) {
      var mm = ProjectPosition.fromJson(json.decode(r));
      if (mm.projectId == projectId) {
        list.add(mm);
      }
    });

    pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵 getProjectPositions: 🦠 ${list.length}');
    return list;
  }

  static Future<List<User>> getUsers() async {
    await _connectToLocalDB();
    Carrier carrier = Carrier(
      db: databaseName,
      collection: Constants.DB_USERS,
    );
    List results = await MobMongo.getAll(carrier);
    List<User> list = List();
    results.forEach((r) {
      var mm = User.fromJson(json.decode(r));
      list.add(mm);
    });

    pp('🔵 🔵 🔵 🔵 🔵 🔵 🔵 getUsers: 🦠 ${list.length}');
    return list;
  }

  static Future<int> addUsers({List<User> users}) async {
    for (var user in users) {
      await addUser(user: user);
    }
    return 0;
  }

  static Future<int> addUser({@required User user}) async {
    await _connectToLocalDB();
    Carrier c = Carrier(db: databaseName, collection: Constants.DB_USERS, id: {
      'field': 'userId',
      'value': user.userId,
    });
    var del = await MobMongo.delete(c);
    pp('🍎 🍎 🍎 addUser: 🌼 1 user deleted...: del $del  🔵 🔵 ');
    Carrier ca = Carrier(
        db: databaseName, collection: Constants.DB_USERS, data: user.toJson());
    var res = await MobMongo.insert(ca);

    pp('🍎 🍎 🍎 addUser: 🌼 1 user added...: res: $res  🔵 🔵 ');
    return cnt;
  }

  static Future<int> addProjects({@required List<Project> projects}) async {
    projects.forEach((element) async {
      await addProject(project: element);
    });
    return 0;
  }

  static Future<int> addProject({@required Project project}) async {
    await _connectToLocalDB();
    Carrier c =
        Carrier(db: databaseName, collection: Constants.DB_PROJECTS, id: {
      'field': 'projectId',
      'value': project.projectId,
    });
    var del = await MobMongo.delete(c);
    pp('🍎 🍎 🍎 addProject: 🌼 ${project.name} deleted? ...: del: $del  🔵 🔵 ');

    try {
      Carrier ca = Carrier(
          db: databaseName,
          collection: Constants.DB_PROJECTS,
          data: project.toJson());

      var res = await MobMongo.insert(ca);
      pp('🍎 🍎 🍎 addProject: 🌼  ${project.name} added...: res: $res  🔵 🔵 ');
    } catch (e) {
      pp('addProject: .... 👺👺👺👺 We are fucked! 👺👺👺👺 ${e.message}');
    }
    return 0;
  }

  static Future<int> addPhotos({@required List<Photo> photos}) async {
    photos.forEach((element) async {
      await addPhoto(photo: element);
    });
    return 0;
  }

  static Future<int> addPhoto({@required Photo photo}) async {
    await _connectToLocalDB();

    Carrier c = Carrier(db: databaseName, collection: Constants.DB_PHOTOS, id: {
      'field': 'photoId',
      'value': photo.photoId,
    });
    var del = await MobMongo.delete(c);
    pp('🍎 🍎 🍎 addPhoto: 🌼 1 photo deleted...: del: $del  🔵 🔵 ');
    Carrier ca = Carrier(
        db: databaseName,
        collection: Constants.DB_PHOTOS,
        data: photo.toJson());
    var res = await MobMongo.insert(ca);

    pp('🍎 🍎 🍎 addPhoto: 🌼 1 photo added...: res $res  🔵 🔵 ');
    return 0;
  }

  static Future<int> addVideos({@required List<Video> videos}) async {
    videos.forEach((element) async {
      await addVideo(video: element);
    });
    return 0;
  }

  static Future<int> addVideo({@required Video video}) async {
    await _connectToLocalDB();

    Carrier c = Carrier(db: databaseName, collection: Constants.DB_VIDEOS, id: {
      'field': 'videoId',
      'value': video.videoId,
    });
    var del = await MobMongo.delete(c);
    pp('🍎 🍎 🍎 addVideo: 🌼 1 video deleted...: del $del  🔵 🔵 ');

    Carrier ca = Carrier(
        db: databaseName,
        collection: Constants.DB_VIDEOS,
        data: video.toJson());
    var res = await MobMongo.insert(ca);

    pp('🍎 🍎 🍎 addVideo: 🌼 1 video added...: res $res  🔵 🔵 ');
    return 0;
  }

  static Future<int> addProjectPositions(
      {@required List<ProjectPosition> positions}) async {
    positions.forEach((element) async {
      await addProjectPosition(projectPosition: element);
    });
    return 0;
  }

  static Future<int> addProjectPosition(
      {@required ProjectPosition projectPosition}) async {
    await _connectToLocalDB();

    Carrier c = Carrier(
        db: databaseName,
        collection: Constants.DB_PROJECT_POSITIONS,
        id: {
          'field': 'created',
          'value': projectPosition.created,
        });
    var del = await MobMongo.delete(c);
    pp('🍎 🍎 🍎 addProjectPosition: 🌼 1 record deleted?...: del $del  🔵 🔵 ');

    Carrier ca = Carrier(
        db: databaseName,
        collection: Constants.DB_PROJECT_POSITIONS,
        data: projectPosition.toJson());
    var res = await MobMongo.insert(ca);

    pp('🍎 🍎 🍎 addProjectPosition: 🌼 1 record added...: res $res  🔵 🔵 ');
    return 0;
  }

  static Future<List<ProjectPosition>> findProjectPositionsByLocation(
      {@required latitude, @required longitude, @required radiusInKM}) async {
    await _connectToLocalDB();
    var radius = radiusInKM * 1000;
    Carrier carrier = Carrier(
        db: databaseName,
        collection: Constants.DB_PROJECT_POSITIONS,
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
    List<ProjectPosition> list = List();
    result.forEach((m) {
      list.add(ProjectPosition.fromJson(json.decode(m)));
    });
    return list;
  }
}
