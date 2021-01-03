import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monitorlibrary/api/local_db_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';

import '../functions.dart';

FCMBloc fcmBloc;
const mm = '🔵 🔵 🔵 🔵 🔵 🔵 FCMBloc: ';

class FCMBloc {
  FirebaseMessaging messaging = FirebaseMessaging();
  FCMBlocListener listener;

  FCMBloc(FCMBlocListener fcmBlocListener) {
    assert(fcmBlocListener != null);
    listener = fcmBlocListener;
    _initialize();
  }

  void _initialize() async {
    pp("$mm initialize ...........................");
    messaging.setAutoInitEnabled(true);
    messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        pp("$mm onMessage: 🍎 🍎  🍎 🍎  🍎 🍎  🍎 🍎  🍎 🍎 fcm message rolling in ...");
        handleMessage(message);
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        pp("$mm onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        pp("$mm onResume: $message");
      },
    );
    subscribeToTopics();
  }

  Future subscribeToTopics() async {
    var user = await Prefs.getUser();
    if (user != null) {
      pp("$mm subscribeToTopics ...........................");
      await messaging.subscribeToTopic('projects_${user.organizationId}');
      await messaging.subscribeToTopic('photos_${user.organizationId}');
      await messaging.subscribeToTopic('videos_${user.organizationId}');
      await messaging.subscribeToTopic('conditions_${user.organizationId}');
      await messaging.subscribeToTopic('messages_${user.organizationId}');
      await messaging.subscribeToTopic('users_${user.organizationId}');
      pp("$mm subscribeToTopics: 🍎 subscribed to all 6 organization topics 🍎");
    }
    return null;
  }

  handleMessage(Map<String, dynamic> message) async {
    pp("$mm handleMessage  🔵 🔵 🔵 .......starting processFCMMessage for: 🔵 $message 🔵");
    await processFCMMessage(message, listener);
  }

  Future processFCMMessage(
      Map<String, dynamic> message, FCMBlocListener listener) async {
    Map data = message['data'];
    if (data != null) {
      if (data['user'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache USER  🍎  🍎 ");
        var m = jsonDecode(data['user']);
        var user = User.fromJson(m);
        await LocalDBAPI.addUser(user: user);
        if (listener != null) listener.onUserMessage(user);
      }
      if (data['project'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache PROJECT  🍎  🍎");
        var m = jsonDecode(data['project']);
        var project = Project.fromJson(m);
        await LocalDBAPI.addProject(project: project);
        if (listener != null) listener.onProjectMessage(project);
      }
      if (data['photo'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache PHOTO  🍎  🍎");
        var m = jsonDecode(data['photo']);
        var photo = Photo.fromJson(m);
        await LocalDBAPI.addPhoto(photo: photo);
        if (listener != null) listener.onPhotoMessage(photo);
      }
      if (data['video'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache VIDEO  🍎  🍎");
        var m = jsonDecode(data['video']);
        var video = Video.fromJson(m);
        await LocalDBAPI.addVideo(video: video);
        if (listener != null) listener.onVideoMessage(video);
      }
      if (data['condition'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache CONDITION  🍎  🍎");
        var m = jsonDecode(data['condition']);
        var condition = Condition.fromJson(m);
        await LocalDBAPI.addCondition(condition: condition);
        if (listener != null) listener.onConditionMessage(condition);
      }
      if (data['message'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache ORG MESSAGE  🍎  🍎");
        var m = jsonDecode(data['message']);
        var msg = OrgMessage.fromJson(m);
        await LocalDBAPI.addOrgMessage(message: msg);
        if (listener != null) listener.onOrgMessage(msg);
      }
    } else {
      pp('👿 👿 👿 No data structure found in FCM message  👿  wtf?  👿 $message');
    }
    return null;
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  pp("$mm  🦠 🦠 🦠 🦠 🦠 myBackgroundMessageHandler   🦠 🦠 🦠 🦠 🦠 ........................... $message");
  Map data = message['data'];
  if (data != null) {
    pp("$mm myBackgroundMessageHandler   🦠 🦠 🦠........................... cache USER  🍎  🍎 string data: $data");
    if (data['user'] != null) {
      var m = jsonDecode(data['user']);
      var user = User.fromJson(m);
      LocalDBAPI.addUser(user: user);
    }
    if (data['project'] != null) {
      pp("$mm myBackgroundMessageHandler   🦠 🦠 🦠 ........................... cache PROJECT  🍎  🍎");
      var m = jsonDecode(data['project']);
      var project = Project.fromJson(m);
      LocalDBAPI.addProject(project: project);
    }
    if (data['photo'] != null) {
      pp("$mm myBackgroundMessageHandler   🦠 🦠 🦠 ........................... cache PHOTO  🍎  🍎");
      var m = jsonDecode(data['photo']);
      var photo = Photo.fromJson(m);
      LocalDBAPI.addPhoto(photo: photo);
    }
    if (data['video'] != null) {
      pp("$mm myBackgroundMessageHandler   🦠 🦠 🦠 ........................... cache VIDEO  🍎  🍎");
      var m = jsonDecode(data['video']);
      var video = Video.fromJson(m);
      LocalDBAPI.addVideo(video: video);
    }
    if (data['condition'] != null) {
      pp("$mm myBackgroundMessageHandler   🦠 🦠 🦠 ........................... cache CONDITION  🍎  🍎");
      var m = jsonDecode(data['condition']);
      var condition = Condition.fromJson(m);
      LocalDBAPI.addCondition(condition: condition);
    }
    if (data['message'] != null) {
      pp("$mm myBackgroundMessageHandler  🦠 🦠 🦠 ........................... cache ORG MESSAGE  🍎  🍎");
      var m = jsonDecode(data['message']);
      var msg = OrgMessage.fromJson(m);
      LocalDBAPI.addOrgMessage(message: msg);
    }
  } else {
    pp('👿 👿 👿 No data structure found in FCM message  👿  wtf?  👿');
  }
}

abstract class FCMBlocListener {
  onProjectMessage(Project project);
  onPhotoMessage(Photo photo);
  onVideoMessage(Video video);
  onUserMessage(User user);
  onConditionMessage(Condition condition);
  onOrgMessage(OrgMessage orgMessage);
}
