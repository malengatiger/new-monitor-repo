import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monitorlibrary/data/user.dart';

class DataAPI {
  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  static const URL = 'http://192.168.86.239:8000/';
//  static const URL = 'https://dancer3033a1.eu-gb.cf.appdomain.cloud/';
//  static const URL = 'https://dancermx.azurewebsites.net/';
//  static const URL = 'https://dancer3033a1.eu-gb.cf.appdomain.cloud/';

  static Future<User> addUser(User user) async{

    Map bag = user.toJson();
    try {
      var result = await _callWebAPIPost(URL + 'addUser', bag);
      return User.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }
  static Future<User> findUserByEmail(String email) async{
    Map bag = {
      'email': email,
    };
    try {
      var result = await _callWebAPIPost(URL + 'findUserByEmail', bag);
      return User.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }
  static Future<User> findUserByUid(String uid) async{
    Map bag = {
      'uid': uid,
    };
    try {
      var result = await _callWebAPIPost(URL + 'findUserByUid', bag);
      return User.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }
  static Future hello() async {
    var result = await _callWebAPIGet(URL);
    debugPrint('DancerAPI: 🔴 🔴 🔴 hello: $result');
  }

  static Future ping() async {
    var result = await _callWebAPIGet(URL + 'ping');
    debugPrint('DancerAPI: 🔴 🔴 🔴 ping: $result');
  }


  static Future _callWebAPIPost(String mUrl, Map bag) async {
    debugPrint(
        '\n\n🏈 🏈 🏈 🏈 🏈 DancerAPI_callWebAPI:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙 print bag ...');
    print(bag);
    var mBag;
    if (bag != null) {
      mBag = json.encode(bag);
    }
    var start = DateTime.now();
    var client = new http.Client();
    try {
      var resp = await client
          .post(
        mUrl,
        body: mBag,
        headers: headers,
      )
          .whenComplete(() {
        //client.close();
      });
      debugPrint(
          '\n\n❤️️❤️  DancerAPI._callWebAPI .... : 💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
      var end = DateTime.now();
      debugPrint(
          '❤️❤️  DancerAPI._callWebAPI ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
      var mJson = json.decode(resp.body);
      return mJson;
    } catch (e) {
      var msg = ('Houston, 👿👿👿👿👿 what the fuck? 👿👿👿👿👿 ');
      debugPrint(e.message);
      throw Exception(msg);
    }
  }

  static Future _callWebAPIGet(String mUrl) async {
    debugPrint(
        '\n\n🏈 🏈 🏈 🏈 🏈 DancerAPI_callWebAPIGet:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙');

    var start = DateTime.now();
    var client = new http.Client();
    try {
      var resp = await client
          .get(
        mUrl,
        headers: headers,
      )
          .whenComplete(() {
        //client.close();
      });
      debugPrint(
          '\n\n❤️️❤️  DancerAPI._callWebAPIGet .... : 💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
      var end = DateTime.now();
      debugPrint(
          '❤️❤️  DancerAPI._callWebAPIGet ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
      var mJson = json.decode(resp.body);
      return mJson;
    } catch (e) {
      var msg = ('Houston, 👿👿👿👿👿 what the fuck? 👿👿👿👿👿 ');
      debugPrint(e.message);
      throw Exception(msg);
    }
  }

}