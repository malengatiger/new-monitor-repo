import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart' as fb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/local_db_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:universal_platform/universal_platform.dart';

import '../functions.dart';

FCMBloc fcmBloc = FCMBloc();
const mm = '🔵 🔵 🔵 🔵 🔵 🔵 FCMBloc: ';

Future<void> firebaseMessagingBackgroundHandler(
    fb.RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class FCMBloc {
  fb.FirebaseMessaging messaging = fb.FirebaseMessaging.instance;

  StreamController<User> _userController = StreamController.broadcast();
  StreamController<Project> _projectController = StreamController.broadcast();
  StreamController<Photo> _photoController = StreamController.broadcast();
  StreamController<Video> _videoController = StreamController.broadcast();
  StreamController<Condition> _conditionController =
      StreamController.broadcast();
  StreamController<OrgMessage> _messageController =
      StreamController.broadcast();

  Stream<User> get userStream => _userController.stream;
  Stream<Project> get projectStream => _projectController.stream;
  Stream<Photo> get photoStream => _photoController.stream;
  Stream<Video> get videoStream => _videoController.stream;
  Stream<Condition> get conditionStream => _conditionController.stream;
  Stream<OrgMessage> get messageStream => _messageController.stream;

  User? user;
  void closeStreams() {
    _userController.close();
    _projectController.close();
    _photoController.close();
    _videoController.close();
    _conditionController.close();
    _messageController.close();
  }

  FCMBloc() {
    initialize();
  }

  void initialize() async {
    pp("$mm initialize FIREBASE MESSAGING ...........................");
    user = await Prefs.getUser();
    var android = UniversalPlatform.isAndroid;
    var ios = UniversalPlatform.isIOS;

    if (android || ios) {
      messaging.setAutoInitEnabled(true);
      messaging.onTokenRefresh.listen((newToken) {
        pp("$mm onTokenRefresh: 🍎 🍎  🍎 🍎 update user: token: $newToken ... 🍎 🍎 ");
        _updateUser(newToken);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        pp("$mm onMessage: 🍎 🍎  data: ${message.data} ... 🍎 🍎 ");
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        pp('$mm onMessageOpenedApp:  🍎 🍎 A new onMessageOpenedApp event was published! ${message.data}');
      });

      await subscribeToTopics();

      if (user != null) {
        var token = await messaging.getToken();
        if (token != user!.fcmRegistration) {
          await _updateUser(token!);
        }
      }
    } else {
      pp('App is running on the web - 👿 👿 👿 firebase messaging NOT initialized 👿 👿 👿 ');
    }
  }

  Future requestPermissions() async {
    fb.NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  // Future listenForMessages() async {
  //   fb.FirebaseMessaging.onMessage.listen((fb.RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');
  //
  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   });
  // }

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
    } else {
      pp("$mm subscribeToTopics:  👿 👿 👿 user not cached on device yet  👿 👿 👿");
    }
    return null;
  }

  Future processFCMMessage(fb.RemoteMessage message) async {
    Map data = message.data;
    if (data != null) {
      if (data['user'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache USER  🍎  🍎 ");
        var m = jsonDecode(data['user']);
        var user = User.fromJson(m);
        await LocalDBAPI.addUser(user: user);
        _userController.sink.add(user);
      }
      if (data['project'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache PROJECT  🍎  🍎");
        var m = jsonDecode(data['project']);
        var project = Project.fromJson(m);
        await LocalDBAPI.addProject(project: project);
        _projectController.sink.add(project);
      }
      if (data['photo'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache PHOTO  🍎  🍎");
        var m = jsonDecode(data['photo']);
        var photo = Photo.fromJson(m);
        await LocalDBAPI.addPhoto(photo: photo);
        _photoController.sink.add(photo);
      }
      if (data['video'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache VIDEO  🍎  🍎");
        var m = jsonDecode(data['video']);
        var video = Video.fromJson(m);
        await LocalDBAPI.addVideo(video: video);
        _videoController.sink.add(video);
      }
      if (data['condition'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache CONDITION  🍎  🍎");
        var m = jsonDecode(data['condition']);
        var condition = Condition.fromJson(m);
        await LocalDBAPI.addCondition(condition: condition);
        _conditionController.sink.add(condition);
      }
      if (data['message'] != null) {
        pp("$mm processFCMMessage  🔵 🔵 🔵 ........................... cache ORG MESSAGE  🍎  🍎");
        var m = jsonDecode(data['message']);
        var msg = OrgMessage.fromJson(m);
        await LocalDBAPI.addOrgMessage(message: msg);
        if (user!.userId != msg.adminId) {
          _messageController.sink.add(msg);
        }
      }
    } else {
      pp('👿 👿 👿 No data structure found in FCM message  👿  wtf?  👿 $message');
    }
    return null;
  }

  Future _updateUser(String newToken) async {
    if (user != null) {
      pp("$mm updateUser: 🍎 🍎  🍎 🍎  🍎 🍎  🍎 🍎  🍎 USER: 🍎 ${user!.toJson()} ... 🍎 🍎 ");
      user!.fcmRegistration = newToken;
      await DataAPI.updateUser(user!);
      await Prefs.saveUser(user!);
    }
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
