import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/organization.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/section.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';

class DataAPI {
  static Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static String activeURL;
  static bool isDevelopmentStatus = true;
  static String url;

  static Future<String> getUrl() async {
    if (url == null) {
      pp('🐤🐤🐤🐤 Getting url via .env settings: ${url == null ? 'NO URL YET' : url}');
      await DotEnv().load('.env');
      String status = DotEnv().env['status'];
      pp('🐤🐤🐤🐤 DataAPI: getUrl: Status from .env: $status');
      if (status == 'dev') {
        isDevelopmentStatus = true;
        url = DotEnv().env['devURL'];
        pp(' 🌎 🌎 🌎 DataAPI: Status of the app is  DEVELOPMENT 🌎 🌎 🌎 $url');
        return url;
      } else {
        isDevelopmentStatus = false;
        url = DotEnv().env['prodURL'];
        pp(' 🌎 🌎 🌎 DataAPI: Status of the app is PRODUCTION 🌎 🌎 🌎 $url');
        return url;
      }
    } else {
      return url;
    }
  }

  static Future<User> addUser(User user) async {
    String mURL = await getUrl();
    Map bag = user.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'addUser', bag);
      return User.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<User> updateUser(User user) async {
    String mURL = await getUrl();
    Map bag = user.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'updateUser', bag);
      return User.fromJson(result);
    } catch (e) {
      pp(e);
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
      pp(e);
      throw e;
    }
  }

  static Future<List<ProjectPosition>> findProjectPositionsById(
      String projectId) async {
    String mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
    };
    try {
      var result = await _callWebAPIGet(
          mURL + 'getProjectPositions?projectId=$projectId');
      List<ProjectPosition> list = List();
      result.forEach((m) {
        list.add(ProjectPosition.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Photo>> findPhotosByProject(String projectId) async {
    String mURL = await getUrl();

    try {
      var result =
          await _callWebAPIGet(mURL + 'getProjectPhotos?projectId=$projectId');
      List<Photo> list = List();
      result.forEach((m) {
        list.add(Photo.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Video>> findVideosById(String projectId) async {
    String mURL = await getUrl();

    try {
      var result =
          await _callWebAPIGet(mURL + 'getProjectVideos?projectId=$projectId');
      List<Video> list = List();
      result.forEach((m) {
        list.add(Video.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<User>> findUsersByOrganization(
      String organizationId) async {
    String mURL = await getUrl();
    var cmd = 'getOrganizationUsers?organizationId=$organizationId';
    var url = '$mURL$cmd';
    try {
      List result = await _callWebAPIGet(url);
      List<User> list = List();
      result.forEach((m) {
        list.add(User.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Project>> findProjectsByOrganization(
      String organizationId) async {
    pp('🍏 🍏 🍏 DataAPI: findProjectsByOrganization: 🍏 id: $organizationId');
    String mURL = await getUrl();
    var cmd = 'findProjectsByOrganization';
    var url = '$mURL$cmd?organizationId=$organizationId';
    try {
      List result = await _callWebAPIGet(url);
      List<Project> list = List();
      result.forEach((m) {
        list.add(Project.fromJson(m));
      });
      return list;
    } catch (e) {
      pp('Houston, 😈😈😈😈😈 we have a problem! 😈😈😈😈😈');
      print(e);
      throw e;
    }
  }

  static Future<List<Project>> findProjectsByLocation(
      {double latitude, double longitude, double radiusInKM}) async {
    pp('🍏 🍏 🍏 DataAPI: findProjectsByLocation: 🍏 radiusInKM: $radiusInKM');
    String mURL = await getUrl();
    var cmd = 'findProjectsByLocation';
    var url =
        '$mURL$cmd?latitude=$latitude&longitude=$longitude&radiusInKM=$radiusInKM';
    try {
      List result = await _callWebAPIGet(url);
      List<Project> list = List();
      result.forEach((m) {
        list.add(Project.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Questionnaire>> getQuestionnairesByOrganization(
      String organizationId) async {
    pp('🍏 🍏 🍏 DataAPI: getQuestionnairesByOrganization: 🍏 id: $organizationId');
    String mURL = await getUrl();
    var cmd = 'getQuestionnairesByOrganization?organizationId=$organizationId';
    var url = '$mURL$cmd';
    try {
      List result = await _callWebAPIGet(url);
      List<Questionnaire> list = List();
      result.forEach((m) {
        list.add(Questionnaire.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Community> updateSettlement(Community settlement) async {
    String mURL = await getUrl();
    Map bag = settlement.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'updateSettlement', bag);
      return Community.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Community> addSettlement(Community settlement) async {
    String mURL = await getUrl();
    Map bag = settlement.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'addSettlement', bag);
      return Community.fromJson(result);
    } catch (e) {
      pp(e);
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
      pp(e);
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
      pp(e);
      throw e;
    }
  }

  static Future<List<Community>> findCommunitiesByCountry(
      String countryId) async {
    String mURL = await getUrl();

    pp('🍏🍏🍏🍏 ..... findCommunitiesByCountry ');
    var cmd = 'findCommunitiesByCountry';
    var url = '$mURL$cmd?countryId=$countryId';

    List result = await _callWebAPIGet(url);
    List<Community> communityList = List();
    result.forEach((m) {
      communityList.add(Community.fromJson(m));
    });
    pp('🍏 🍏 🍏 findCommunitiesByCountry found ${communityList.length}');
    return communityList;
  }

  static Future<Project> addProject(Project project) async {
    String mURL = await getUrl();
    Map bag = project.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'addProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Project> updateProject(Project project) async {
    String mURL = await getUrl();
    Map bag = project.toJson();
    try {
      var result = await _callWebAPIPost(mURL + 'updateProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      pp(e);
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
      pp(e);
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
      pp(e);
      throw e;
    }
  }

  static Future addPhoto(Photo photo) async {
    String mURL = await getUrl();
    try {
      var result = await _callWebAPIPost(mURL + 'addPhoto', photo.toJson());
      return result;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future addVideo(Video video) async {
    String mURL = await getUrl();

    try {
      var result = await _callWebAPIPost(mURL + 'addVideo', video.toJson());
      pp(result);
      return result;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future addCondition(Condition condition) async {
    String mURL = await getUrl();

    try {
      var result = await _callWebAPIPost(mURL + 'addVideo', condition.toJson());
      pp(result);
      return result;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Community> addSettlementPhoto(
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
      return Community.fromJson(result);
    } catch (e) {
      pp(e);
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
      pp(e);
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
      pp(e);
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
      pp(e);
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
      pp(e);
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
      pp(e);
      throw e;
    }
  }

  static Future<User> findUserByEmail(String email) async {
    pp('🐤🐤🐤🐤 DataAPI : ... findUserByEmail $email ');
    String mURL = await getUrl();
    assert(mURL != null);
    var command = "findUserByEmail?email=$email";

    try {
      pp('🐤🐤🐤🐤 DataAPI : ... 🥏 calling _callWebAPIPost .. 🥏 findUserByEmail $email ');
      var result = await _callWebAPIGet(
        '$mURL$command',
      );
      pp(result);
      return User.fromJson(result);
    } catch (e) {
      pp(e);
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
      pp(e);
      throw e;
    }
  }

  static Future<List<Country>> getCountries() async {
    String mURL = await getUrl();
    var cmd = 'getCountries';
    var url = '$mURL$cmd';
    try {
      List result = await _callWebAPIGet(url);
      List<Country> list = List();
      result.forEach((m) {
        list.add(Country.fromJson(m));
      });
      pp('🐤🐤🐤🐤 ${list.length} Countries found 🥏');
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future hello() async {
    String mURL = await getUrl();
    var result = await _callWebAPIGet(mURL);
    pp('DataAPI: 🔴 🔴 🔴 hello: $result');
  }

  static Future ping() async {
    String mURL = await getUrl();
    var result = await _callWebAPIGet(mURL + 'ping');
    pp('DataAPI: 🔴 🔴 🔴 ping: $result');
  }

  static Future _callWebAPIPost(String mUrl, Map bag) async {
    pp('\n\n🏈 🏈 🏈 🏈 🏈 DataAPI_callWebAPIPost:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙 print bag ...');

    var mBag;
    if (bag != null) {
      mBag = json.encode(bag);
    }

    var start = DateTime.now();
    var client = new http.Client();
    var token = await AppAuth.getAuthToken();
    headers['Authorization'] = 'Bearer $token';

    var resp = await client
        .post(
          mUrl,
          body: mBag,
          headers: headers,
        )
        .whenComplete(() {});
    if (resp.statusCode == 200) {
      pp('\n\n❤️️❤️  DataAPI._callWebAPIPost .... : 💙💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
    } else {
      pp('\n\n👿👿👿 DataAPI._callWebAPIPost .... : 🔆 statusCode: 👿👿👿 ${resp.statusCode} 🔆🔆🔆 for $mUrl');
      throw Exception('🚨 🚨 Status Code 🚨 ${resp.statusCode} 🚨 Exception');
    }
    var end = DateTime.now();
    pp('❤️❤️ 💙 DataAPI._callWebAPIPost ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
    pp(resp.body);
    try {
      var mJson = json.decode(resp.body);
      pp('❤️❤️ 💙 DataAPI._callWebAPIPost ,,,,,,,,,,,,,,,,,,, do we get here?');
      return mJson;
    } catch (e) {
      pp("👿👿👿👿👿👿👿 json.decode failed, returning response body");
      return resp.body;
    }
  }

  static Future _callWebAPIGet(String mUrl) async {
    pp('\n🏈 🏈 🏈 🏈 🏈 DataAPI_callWebAPIGet:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙');
    var start = DateTime.now();
    var client = new http.Client();
    var token = await AppAuth.getAuthToken();
    headers['Authorization'] = 'Bearer $token';

    var resp = await client
        .get(
          mUrl,
          headers: headers,
        )
        .whenComplete(() {});
    pp('\n\n❤️️❤️  DataAPI._callWebAPIGet .... : 💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
    var end = DateTime.now();
    pp('❤️❤️  DataAPI._callWebAPIGet ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
    sendError(resp);
    var mJson = json.decode(resp.body);
    return mJson;
  }

  static void sendError(http.Response resp) {
    if (resp.statusCode != 200) {
      var msg =
          '😡 😡 The response is not 200; it is ${resp.statusCode}, NOT GOOD, throwing up !! 🥪 🥙 🌮  😡';
      pp(msg);
      throw Exception(msg);
    }
  }
}
