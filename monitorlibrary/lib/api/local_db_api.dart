import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../functions.dart';

class LocalDBAPI {
  static const APP_ID = 'monAppID_0';
  static bool dbConnected = false;
  static int cnt = 0;

  static String databaseName = 'MonDB001a';

  static Box projectBox;
  static Box photoBox;
  static Box videoBox;
  static Box userBox;
  static Box projectPositionBox;
  static Box conditionBox;
  static Box orgMessageBox;

  static const aa = 'AnchorLocalDB: 🦠🦠🦠🦠🦠 ';

  static Future connectLocalDB() async {
    if (projectBox == null) {
      pp('$aa Connecting to Hive, getting document directory on device ... ');
      final appDocumentDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
      pp('$aa Hive local data will be stored here ... '
          ' 🍎 🍎 ${appDocumentDirectory.path}');
      projectBox = await Hive.openBox("agentBox");
      pp('$aa Hive agentBox:  🔵  ....agentBox.isOpen: ${projectBox.isOpen}');
      photoBox = await Hive.openBox("clientBox");
      pp('$aa Hive clientBox:  🔵  ....clientBox.isOpen: ${photoBox.isOpen}');
      videoBox = await Hive.openBox("balanceBox");
      pp('$aa Hive balanceBox:  🔵  ....balanceBox.isOpen: ${videoBox.isOpen}');
      userBox = await Hive.openBox("userBox");
      pp('$aa Hive userBox:  🔵  ....userBox.isOpen: ${userBox.isOpen}');

      projectPositionBox = await Hive.openBox("projectPositionBox");
      pp('$aa Hive projectPositionBox:  🔵  ....projectPositionBox.isOpen: ${projectPositionBox.isOpen}');

      conditionBox = await Hive.openBox("conditionBox");
      pp('$aa Hive conditionBox:  🔵  ....conditionBox.isOpen: ${conditionBox.isOpen}');

      orgMessageBox = await Hive.openBox("orgMessageBox");
      pp('$aa Hive orgMessageBox:  🔵  ....orgMessageBox.isOpen: ${conditionBox.isOpen}');
      pp('$aa Hive local data ready to rumble ....$aa');
    }
  }

  static Future<List<Project>> getProjects() async {
    await connectLocalDB();
    List<Project> mList = [];
    List list = projectBox.values.toList();
    list.forEach((element) {
      mList.add(Project.fromJson(element));
    });
    return mList;
  }

  static Future<List<Photo>> getPhotos() async {
    await connectLocalDB();
    List<Photo> mList = [];
    List list = photoBox.values.toList();
    list.forEach((element) {
      mList.add(Photo.fromJson(element));
    });
    pp('$mx LocalDBAPI: getPhotos: 🦠 ${list.length} 🦠');
    return mList;
  }

  static Future<List<Video>> getVideos() async {
    await connectLocalDB();
    List<Video> mList = [];
    List list = videoBox.values.toList();
    list.forEach((element) {
      mList.add(Video.fromJson(element));
    });
    pp('$mx getVideos: 🦠 ${mList.length}');
    return mList;
  }

  static Future<List<Photo>> getProjectPhotos(String projectId) async {
    await connectLocalDB();

    List<Photo> mList = [];
    List list = photoBox.values.toList();
    list.forEach((element) {
      var photo = Photo.fromJson(element);
      if (photo.projectId == projectId) {
        mList.add(photo);
      }
    });

    pp('$mx getProjectPhotos: 🦠 ${mList.length}');
    return mList;
  }

  static Future<List<Photo>> getUserPhotos(String userId) async {
    await connectLocalDB();
    List<Photo> mList = [];
    List list = photoBox.values.toList();
    list.forEach((element) {
      var photo = Photo.fromJson(element);
      if (photo.userId == userId) {
        mList.add(photo);
      }
    });
    pp('$mx ...... getUserPhotos, AFTER filter: 🦠 ${mList.length}');
    return mList;
  }

  static Future<List<Video>> getProjectVideos(String projectId) async {
    await connectLocalDB();

    List<Video> mList = [];
    List list = videoBox.values.toList();
    list.forEach((element) {
      var vid = Video.fromJson(element);
      if (vid.projectId == projectId) {
        mList.add(vid);
      }
    });

    pp('$mx getProjectVideos: 🦠 ${mList.length}');
    return mList;
  }

  static Future<List<Video>> getUserVideos(String userId) async {
    await connectLocalDB();

    List<Video> mList = [];
    List list = videoBox.values.toList();
    list.forEach((element) {
      var vid = Video.fromJson(element);
      if (vid.userId == userId) {
        mList.add(vid);
      }
    });
    pp('$mx getUserVideos, AFTER filter: 🦠 ${mList.length}');
    return mList;
  }

  static Future<List<ProjectPosition>> getProjectPositions(
      String projectId) async {
    await connectLocalDB();
    List<ProjectPosition> mList = [];
    List list = projectPositionBox.values.toList();
    list.forEach((element) {
      var pos = ProjectPosition.fromJson(element);
      if (pos.projectId == projectId) {
        mList.add(pos);
      }
    });
    pp('$mx getProjectPositions: 🦠 ${mList.length}');
    return mList;
  }

  static const mx = '🍎 🍎 🍎 LocalDBAPI: 🍎 ';
  static Future<List<User>> getUsers() async {
    await connectLocalDB();

    List<User> mList = [];
    List list = userBox.values.toList();
    list.forEach((element) {
      mList.add(User.fromJson(element));
    });
    pp('$mx LocalDBAPI:getUsers: 🦠 ${mList.length}');
    return mList;
  }

  static Future<int> addUsers({List<User> users}) async {
    for (var user in users) {
      await addUser(user: user);
    }
    return 0;
  }

  static Future<int> addUser({@required User user}) async {
    await connectLocalDB();
    await userBox.put(user.userId, user.toJson());
    pp('$mx addUser: 🌼 1 user added...:  🔵 🔵 ');
    return cnt;
  }

  static Future<int> addProjects({@required List<Project> projects}) async {
    projects.forEach((element) async {
      await addProject(project: element);
    });
    return 0;
  }

  static Future<int> addProject({@required Project project}) async {
    await connectLocalDB();
    await projectBox.put(project.projectId, project.toJson());
    pp('$mx addProject: 🌼 1 project added...:  🔵 🔵 ');
    return 0;
  }

  static Future<int> addPhotos({@required List<Photo> photos}) async {
    photos.forEach((element) async {
      await addPhoto(photo: element);
    });
    return 0;
  }

  static Future<int> addPhoto({@required Photo photo}) async {
    await connectLocalDB();
    await photoBox.put(photo.photoId, photo.toJson());
    pp('$mx addPhoto: 🌼 1 photo added...  🔵 🔵 ');
    return 0;
  }

  static Future<int> addVideos({@required List<Video> videos}) async {
    videos.forEach((element) async {
      await addVideo(video: element);
    });
    return 0;
  }

  static Future<int> addVideo({@required Video video}) async {
    await connectLocalDB();
    await videoBox.put(video.videoId, video.toJson());
    pp('$mx addVideo: 🌼 1 video added...  🔵 🔵 ');
    return 0;
  }

  static Future<int> addCondition({@required Condition condition}) async {
    await connectLocalDB();

    await conditionBox.put(DateTime.now().toString(), condition.toJson());
    pp('$mx addCondition: 🌼 1 condition added...:  🔵 🔵 ');
    return 0;
  }

  static Future<int> addOrgMessage({@required OrgMessage message}) async {
    await connectLocalDB();
    await orgMessageBox.put(message.created, message.toJson());
    pp('$mx addOrgMessage: 🌼 1 OrgMessage added ...  🔵 🔵 ');
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
    await connectLocalDB();
    await projectPositionBox.put(
        projectPosition.created, projectPosition.toJson());

    pp('$mx addProjectPosition: 🌼 1 record added ... 🔵 🔵 ');
    return 0;
  }

  static Future<List<ProjectPosition>> findProjectPositionsByLocation(
      {@required latitude, @required longitude, @required radiusInKM}) async {
    await connectLocalDB();

    List<ProjectPosition> list = [];

    return list;
  }
}