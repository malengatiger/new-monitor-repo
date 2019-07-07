import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/organization.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/settlement.dart';
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

  static Future<User> addUser(User user) async {
    Map bag = user.toJson();
    try {
      var result = await _callWebAPIPost(URL + 'addUser', bag);
      return User.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<User>> findUsersByOrganization(
      String organizationId) async {
    Map bag = {
      'organizationId': organizationId,
    };
    try {
      List result = await _callWebAPIPost(URL + 'findUsersByOrganization', bag);
      List<User> list = List();
      result.forEach((m) {
        list.add(User.fromJson(m));
      });
      return list;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Settlement> addSettlement(Settlement settlement) async {
    Map bag = settlement.toJson();
    try {
      var result = await _callWebAPIPost(URL + 'addSettlement', bag);
      return Settlement.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }
  static Future addPointToPolygon({@required String settlementId,
    @required double latitude, @required double longitude}) async {
    Map bag = {
      'settlementId': settlementId,
      'latitude': latitude,
      'longitude': longitude,

    };
    try {
      var result = await _callWebAPIPost(URL + 'addPointToPolygon', bag);
      return result;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Settlement>> findSettlementsByCountry(
      String countryId) async {
    Map bag = {
      'countryId': countryId,
    };
    print('🍏 findSettlementsByCountry ');
    try {
      List result =
          await _callWebAPIPost(URL + 'findSettlementsByCountry', bag);
      List<Settlement> list = List();
      result.forEach((m) {
        list.add(Settlement.fromJson(m));
      });
      print('🍏 🍏 🍏 found ${list.length}');
      return list;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Project> addProject(Project settlement) async {
    Map bag = settlement.toJson();
    try {
      var result = await _callWebAPIPost(URL + 'addProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Questionnaire> addQuestionnaire(
      Questionnaire questionnaire) async {
    Map bag = questionnaire.toJson();
    try {
      var result = await _callWebAPIPost(URL + 'addQuestionnaire', bag);
      return Questionnaire.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Questionnaire>> getQuestionnairesByOrganization(
      String organizationId) async {
    Map bag = {
      'organizationId': organizationId,
    };
    try {
      List result =
          await _callWebAPIPost(URL + 'getQuestionnairesByOrganization', bag);
      List<Questionnaire> list = List();
      result.forEach((m) {
        list.add(Questionnaire.fromJson(m));
      });
      return list;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Organization> addOrganization(Organization org) async {
    Map bag = org.toJson();
    try {
      var result = await _callWebAPIPost(URL + 'addOrganization', bag);
      return Organization.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<User> findUserByEmail(String email) async {
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

  static Future<User> findUserByUid(String uid) async {
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
  static Future<List<Country>> getCountries() async {
    Map bag = {
    };
    try {
      List result = await _callWebAPIPost(URL + 'getCountries', bag);
      List<Country> list = List();
      result.forEach((m) {
        list.add( Country.fromJson(m));
      });

      return list;
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
      if (resp.statusCode == 200) {
        debugPrint(
            '\n\n❤️️❤️  DancerAPI._callWebAPI .... : 💙 statusCode: 👌👌👌 ${resp
                .statusCode} 👌👌👌 💙 for $mUrl');
      } else {
        debugPrint(
            '\n\n👿👿👿 DancerAPI._callWebAPI .... : 🔆 statusCode: 👿👿👿 ${resp
                .statusCode} 🔆🔆🔆 for $mUrl');
      }
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
