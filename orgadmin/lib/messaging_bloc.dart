import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/Constants.dart';
import 'package:monitorlibrary/functions.dart';

class AdminMessagingBloc {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  AdminMessagingBloc() {
    initialize();
  }

  subscribe() {
    debugPrint('\n\n🍏🍏 💙💙💙 💙💙💙 AdminMessagingBloc: Subscribe to FCM topics ... 💙💙💙💙💙💙 🍏🍏');
    firebaseMessaging.subscribeToTopic(Constants.TOPIC_USERS);
    firebaseMessaging.subscribeToTopic(Constants.TOPIC_SETTLEMENTS);
    firebaseMessaging.subscribeToTopic(Constants.TOPIC_PROJECTS);
    firebaseMessaging.subscribeToTopic(Constants.TOPIC_QUESTIONNAIRES);
    firebaseMessaging.subscribeToTopic(Constants.TOPIC_ORGANIZATIONS);
    debugPrint('💙💙💙 🍎🍎🍎🍎 AdminMessagingBloc: Subscriptions to FCM topics completed. 🍎🍎🍎🍎🍎🍎');
    debugPrint('🔆🔆🔆🔆 topics: 🔆 ${Constants.TOPIC_USERS} 🔆 ${Constants.TOPIC_SETTLEMENTS} 🔆 ${Constants.TOPIC_PROJECTS} 🔆 ${Constants.TOPIC_ORGANIZATIONS} 🔆 ${Constants.TOPIC_QUESTIONNAIRES} 🔆🔆🔆🔆 \n\n');
  }

  initialize() async {
    debugPrint(
        "🍎🍎🍎🍎 AdminMessagingBloc: initialize: Setting up FCM messaging 🧡💛🧡💛 configurations & streams: 🧡💛 ${DateTime.now().toIso8601String()}");
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var mJson = json.decode(message['data']);
        print(
            "\n\n🍏🍏 AdminMessagingBloc: 🍏🍏 onMessage: 🍏🍏 type: 🔵 ${mJson['type']} 🔵 🧡🧡🧡 $message 🍎🍎🍎");
        prettyPrint(mJson,
            '🧡🧡🧡🧡🧡🧡 🍎 AdminMessagingBloc: Message Received 🍎 from 💙💙💙 FCM 💙💙💙 🧡🧡🧡🧡🧡🧡 ');
        var type = mJson['type'];
        print('🍏🍏🍏🍏🍏🍏🍏🍏🍏🍏 AdminMessagingBloc: type of message: $type 💙💙💙');
        prettyPrint(mJson, 'AdminMessagingBloc: ********* 🐥🐥🐥🐥🐥 json payload');
        switch (type) {
          case Constants.TOPIC_USERS:
            _userController.sink.add(message);
            break;
          case Constants.TOPIC_SETTLEMENTS:
            _settController.sink.add(message);
            break;
          case Constants.TOPIC_PROJECTS:
            _projectController.sink.add(message);
            break;
          case Constants.TOPIC_QUESTIONNAIRES:
            _questController.sink.add(message);
            break;
          case Constants.TOPIC_ORGANIZATIONS:
            _orgController.sink.add(message);
            break;
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("🍏🍏 🍏🍏 onLaunch: $message 🧡💛");
      },
      onResume: (Map<String, dynamic> message) async {
        print("🍏🍏 🍏🍏 onResume: $message");
      },
    );
    var token = await firebaseMessaging.getToken();
    debugPrint('🧩🧩🧩🧩🧩🧩 AdminMessagingBloc: FCM token: 🧩🧩🧩🧩🧩🧩🧩🧩 🐥🐥🐥🐥🐥 $token 🐥🐥🐥🐥🐥');
    subscribe();
  }

  StreamController _userController = StreamController.broadcast();
  StreamController _settController = StreamController.broadcast();
  StreamController _projectController = StreamController.broadcast();
  StreamController _questController = StreamController.broadcast();
  StreamController _orgController = StreamController.broadcast();

  Stream get userStream => _userController.stream;

  Stream get settlementStream => _settController.stream;

  Stream get projectStream => _projectController.stream;

  Stream get questionnaireStream => _questController.stream;

  Stream get organizationStream => _orgController.stream;

  closeStreams() {
    _userController.close();
    _settController.close();
    _projectController.close();
    _questController.close();
    _orgController.close();
  }
}
