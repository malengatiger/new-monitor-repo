import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/organization.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/section.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';

class DataAPI {
  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
//  static const URL = 'http://192.168.86.240:8000/';
//  static const URL = 'https://dancer3033a1.eu-gb.cf.appdomain.cloud/';
//  static const URL = 'https://monitorz.azurewebsites.net/';
//  static const URL = 'https://dancer3033a1.eu-gb.cf.appdomain.cloud/';

  static String activeURL;
  static bool isDevelopmentStatus = true;
  static Future<String> getUrl() async {
    await DotEnv().load('.env');
    String status = DotEnv().env['status'];
    if (status == 'dev') {
      isDevelopmentStatus = true;
      String url = DotEnv().env['devURL'];
      return url;
    } else {
      isDevelopmentStatus = false;
      String url = DotEnv().env['prodURL'];
      return url;
    }
    print(
        ' 🌎 🌎 🌎 Status of the app is ${isDevelopmentStatus ? 'DEVELOPMENT' : 'PRODUCTION'}  🌎 🌎 🌎');
  }

  static Future<User> addUser(User user) async {
    String mURL = await getUrl();
    Map bag = user.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'addUser', bag);
      return User.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Project> findProjectById(String projectId) async {
    String mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
    };
    try {
      var result = await _callWebAPIPost(mURL + 'findProjectById', bag);
      return Project.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<User>> findUsersByOrganization(
      String organizationId) async {
    String mURL = await getUrl();
    Map bag = {
      'organizationId': organizationId,
    };
    try {
      List result =
          await _callWebAPIPost(mURL + 'findUsersByOrganization', bag);
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

  static Future<List<Project>> findProjectsByOrganization(
      String organizationId) async {
    String mURL = await getUrl();
    Map bag = {
      'organizationId': organizationId,
    };
    try {
      List result =
          await _callWebAPIPost(mURL + 'findProjectsByOrganization', bag);
      List<Project> list = List();
      result.forEach((m) {
        list.add(Project.fromJson(m));
      });
      return list;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Questionnaire>> getQuestionnairesByOrganization(
      String organizationId) async {
    String mURL = await getUrl();
    Map bag = {
      'organizationId': organizationId,
    };
    try {
      List result =
          await _callWebAPIPost(mURL + 'getQuestionnairesByOrganization', bag);
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

  static Future<Settlement> updateSettlement(Settlement settlement) async {
    String mURL = await getUrl();
    Map bag = settlement.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'updateSettlement', bag);
      return Settlement.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Settlement> addSettlement(Settlement settlement) async {
    String mURL = await getUrl();
    Map bag = settlement.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'addSettlement', bag);
      return Settlement.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future addPointToPolygon(
      {@required String settlementId,
      @required double latitude,
      @required double longitude}) async {
    String mURL = await getUrl();
    Map bag = {
      'settlementId': settlementId,
      'latitude': latitude,
      'longitude': longitude,
    };
    try {
      var result = await _callWebAPIPost(mURL + 'addPointToPolygon', bag);
      return result;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future addQuestionnaireSection(
      {@required String questionnaireId, @required Section section}) async {
    String mURL = await getUrl();
    Map bag = {
      'questionnaireId': questionnaireId,
      'section': section.toJson(),
    };
    try {
      var result = await _callWebAPIPost(mURL + 'addQuestionnaireSection', bag);
      return result;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Settlement>> findSettlementsByCountry(
      String countryId) async {
    String mURL = await getUrl();
    Map bag = {
      'countryId': countryId,
    };
    print('🍏 findSettlementsByCountry ');
    try {
      List result =
          await _callWebAPIPost(mURL + 'findSettlementsByCountry', bag);
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

  static Future<Project> addProject(Project project) async {
    String mURL = await getUrl();
    Map bag = project.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'addProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Project> addSettlementToProject(
      {String projectId, String settlementId}) async {
    String mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
      'settlementId': settlementId,
    };
    try {
      var result = await _callWebAPIPost(mURL + 'addSettlementToProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Project> addPositionsToProject(
      {String projectId, List<Position> positions}) async {
    String mURL = await getUrl();
    List mPos = List();
    positions.forEach((p) {
      mPos.add(p.toJson());
    });
    Map bag = {
      'projectId': projectId,
      'settlementId': mPos,
    };
    try {
      var result = await _callWebAPIPost(mURL + 'addPositionsToProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Project> addProjectPhoto(
      {String projectId,
      String url,
      double latitude,
      longitude,
      String userId}) async {
    String mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
      'url': url,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
    };
    try {
      var result = await _callWebAPIPost(mURL + 'addProjectPhoto', bag);
      print(result);
      return Project.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Settlement> addSettlementPhoto(
      {String settlementId,
      String url,
      String comment,
      double latitude,
      longitude,
      String userId}) async {
    String mURL = await getUrl();
    Map bag = {
      'settlementId': settlementId,
      'url': url,
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
    };
    try {
      var result = await _callWebAPIPost(mURL + 'addSettlementPhoto', bag);
      return Settlement.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Project> addProjectVideo(
      {String projectId,
      String url,
      String comment,
      double latitude,
      longitude,
      String userId}) async {
    String mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
      'url': url,
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId
    };
    try {
      var result = await _callWebAPIPost(mURL + 'addProjectVideo', bag);
      return Project.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Project> addProjectRating(
      {String projectId,
      String rating,
      String comment,
      double latitude,
      longitude,
      String userId}) async {
    String mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
      'rating': rating,
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId
    };
    try {
      var result = await _callWebAPIPost(mURL + 'addProjectRating', bag);
      return Project.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Questionnaire> addQuestionnaire(
      Questionnaire questionnaire) async {
    String mURL = await getUrl();
    Map bag = questionnaire.toJson();
    prettyPrint(bag,
        'DataAPI  💦 💦 💦 addQuestionnaire: 🔆🔆 Sending to web api ......');
    try {
      var result = await _callWebAPIPost(mURL + 'addQuestionnaire', bag);
      return Questionnaire.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Project>> findAllProjects(String organizationId) async {
    String mURL = await getUrl();
    Map bag = {};
    try {
      List result = await _callWebAPIPost(mURL + 'findAllProjects', bag);
      List<Project> list = List();
      result.forEach((m) {
        list.add(Project.fromJson(m));
      });
      return list;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Organization> addOrganization(Organization org) async {
    String mURL = await getUrl();
    Map bag = org.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'addOrganization', bag);
      return Organization.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<User> findUserByEmail(String email) async {
    String mURL = await getUrl();
    Map bag = {
      'email': email,
    };
    try {
      var result = await _callWebAPIPost(mURL + 'findUserByEmail', bag);
      return User.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<User> findUserByUid(String uid) async {
    String mURL = await getUrl();
    Map bag = {
      'uid': uid,
    };
    try {
      var result = await _callWebAPIPost(mURL + 'findUserByUid', bag);
      return User.fromJson(result);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Country>> getCountries() async {
    String mURL = await getUrl();
    Map bag = {};
    try {
      List result = await _callWebAPIPost(mURL + 'getCountries', bag);
      List<Country> list = List();
      result.forEach((m) {
        list.add(Country.fromJson(m));
      });

      return list;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future hello() async {
    String mURL = await getUrl();
    var result = await _callWebAPIGet(mURL);
    debugPrint('DataAPI: 🔴 🔴 🔴 hello: $result');
  }

  static Future ping() async {
    String mURL = await getUrl();
    var result = await _callWebAPIGet(mURL + 'ping');
    debugPrint('DataAPI: 🔴 🔴 🔴 ping: $result');
  }

  static Future _callWebAPIPost(String mUrl, Map bag) async {
    debugPrint(
        '\n\n🏈 🏈 🏈 🏈 🏈DataAPI_callWebAPI:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙 print bag ...');
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
            '\n\n❤️️❤️  DataAPI._callWebAPI .... : 💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
      } else {
        debugPrint(
            '\n\n👿👿👿 DataAPI._callWebAPI .... : 🔆 statusCode: 👿👿👿 ${resp.statusCode} 🔆🔆🔆 for $mUrl');
        throw Exception('🚨 🚨 Status Code 🚨 ${resp.statusCode} 🚨 Exception');
      }
      var end = DateTime.now();
      debugPrint(
          '❤️❤️  DataAPI._callWebAPI ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
      var mJson = json.decode(resp.body);
      return mJson;
    } catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
  }

  static Future _callWebAPIGet(String mUrl) async {
    debugPrint(
        '\n\n🏈 🏈 🏈 🏈 🏈DataAPI_callWebAPIGet:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙');

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
          '\n\n❤️️❤️  DataAPI._callWebAPIGet .... : 💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
      var end = DateTime.now();
      debugPrint(
          '❤️❤️  DataAPI._callWebAPIGet ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
      var mJson = json.decode(resp.body);
      return mJson;
    } catch (e) {
      var msg = ('Houston, 👿👿👿👿👿 what the fuck? 👿👿👿👿👿 ');
      debugPrint(e.message);
      throw Exception(msg);
    }
  }
}
