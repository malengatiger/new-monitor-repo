import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot;
import 'package:http/http.dart' as http;
import 'package:monitorlibrary/api/local_db_api.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/data/city.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/counters.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/field_monitor_schedule.dart';
import 'package:monitorlibrary/data/organization.dart';
import 'package:monitorlibrary/data/photo.dart';
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

  static String? activeURL;
  static bool isDevelopmentStatus = true;
  static String? url;

  static Future<String?> getUrl() async {
    if (url == null) {
      pp('🐤🐤🐤🐤 Getting url via .env settings: ${url == null ? 'NO URL YET' : url}');
      String? status = dot.dotenv.env['status'];
      pp('🐤🐤🐤🐤 DataAPI: getUrl: Status from .env: $status');
      if (status == 'dev') {
        isDevelopmentStatus = true;
        url = dot.dotenv.env['devURL'];
        pp(' 🌎 🌎 🌎 DataAPI: Status of the app is  DEVELOPMENT 🌎 🌎 🌎 $url');
        return url!;
      } else {
        isDevelopmentStatus = false;
        url = dot.dotenv.env['prodURL'];
        pp(' 🌎 🌎 🌎 DataAPI: Status of the app is PRODUCTION 🌎 🌎 🌎 $url');
        return url!;
      }
    } else {
      return url!;
    }
  }

  static Future<FieldMonitorSchedule> addFieldMonitorSchedule(
      FieldMonitorSchedule monitorSchedule) async {
    String? mURL = await getUrl();
    Map bag = monitorSchedule.toJson();
    pp('DataAPI: ☕️ ☕️ ☕️ bag about to be sent to backend: check name: ☕️ $bag');
    try {
      var result = await _callWebAPIPost(mURL! + 'addFieldMonitorSchedule', bag);
      return FieldMonitorSchedule.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<FieldMonitorSchedule>> getProjectFieldMonitorSchedules(
      String projectId) async {
    String? mURL = await getUrl();
    List<FieldMonitorSchedule> mList = [];
    try {
      List result = await _sendHttpGET(
          mURL! + 'getProjectFieldMonitorSchedules?projectId=$projectId');
      result.forEach((element) {
        mList.add(FieldMonitorSchedule.fromJson(element));
      });
      pp('🌿 🌿 🌿 getProjectFieldMonitorSchedules returned: 🌿 ${mList.length}');
      return mList;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<FieldMonitorSchedule>> getMonitorFieldMonitorSchedules(
      String userId) async {
    String? mURL = await getUrl();
    List<FieldMonitorSchedule> mList = [];
    try {
      List result = await _sendHttpGET(
          mURL! + 'getMonitorFieldMonitorSchedules?userId=$userId');
      result.forEach((element) {
        mList.add(FieldMonitorSchedule.fromJson(element));
      });
      pp('🌿 🌿 🌿 getMonitorFieldMonitorSchedules returned: 🌿 ${mList.length}');
      return mList;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<FieldMonitorSchedule>> getOrgFieldMonitorSchedules(
      String organizationId) async {
    String? mURL = await getUrl();
    List<FieldMonitorSchedule> mList = [];
    try {
      List result = await _sendHttpGET(
          mURL! + 'getOrgFieldMonitorSchedules?organizationId=$organizationId');
      result.forEach((element) {
        mList.add(FieldMonitorSchedule.fromJson(element));
      });
      pp('🌿 🌿 🌿 getOrgFieldMonitorSchedules returned: 🌿 ${mList.length}');
      return mList;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<User> addUser(User user) async {
    String? mURL = await getUrl();
    Map bag = user.toJson();
    pp('DataAPI: ☕️ ☕️ ☕️ bag about to be sent to backend: check name: ☕️ $bag');
    try {
      var result = await _callWebAPIPost(mURL! + 'addUser', bag);
      return User.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<User> updateUser(User user) async {
    String? mURL = await getUrl();
    Map bag = user.toJson();
    try {
      var result = await _callWebAPIPost(mURL! + 'updateUser', bag);
      var users = findUsersByOrganization(user.organizationId!);
      return User.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<ProjectCount> getProjectCount(String projectId) async {
    String? mURL = await getUrl();
    try {
      var result =
          await _sendHttpGET(mURL! + 'getCountsByProject?projectId=$projectId');
      var cnt = ProjectCount.fromJson(result);
      pp('🌿 🌿 🌿 Project count returned: 🌿 ${cnt.toJson()}');
      return cnt;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<UserCount> getUserCount(String userId) async {
    String? mURL = await getUrl();
    try {
      var result = await _sendHttpGET(mURL! + 'getCountsByUser?userId=$userId');
      var cnt = UserCount.fromJson(result);
      pp('🌿 🌿 🌿 User count returned: 🌿 ${cnt.toJson()}');
      return cnt;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Project> findProjectById(String projectId) async {
    String? mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
    };
    try {
      var result = await _callWebAPIPost(mURL! + 'findProjectById', bag);
      return Project.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<ProjectPosition>> findProjectPositionsById(
      String projectId) async {
    String? mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
    };
    try {
      var result =
          await _sendHttpGET(mURL! + 'getProjectPositions?projectId=$projectId');
      List<ProjectPosition> list = [];
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
    String? mURL = await getUrl();

    try {
      var result =
          await _sendHttpGET(mURL! + 'getProjectPhotos?projectId=$projectId');
      List<Photo> list = [];
      result.forEach((m) {
        list.add(Photo.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Photo>> getUserProjectPhotos(String userId) async {
    String? mURL = await getUrl();

    try {
      var result =
          await _sendHttpGET(mURL! + 'getUserProjectPhotos?userId=$userId');
      List<Photo> list = [];
      result.forEach((m) {
        list.add(Photo.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Video>> getUserProjectVideos(String userId) async {
    String? mURL = await getUrl();

    try {
      var result =
          await _sendHttpGET(mURL! + 'getUserProjectVideos?userId=$userId');
      List<Video> list = [];
      result.forEach((m) {
        list.add(Video.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Video>> findVideosById(String projectId) async {
    String? mURL = await getUrl();

    try {
      var result =
          await _sendHttpGET(mURL! + 'getProjectVideos?projectId=$projectId');
      List<Video> list = [];
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
    String? mURL = await getUrl();
    var cmd = 'getOrganizationUsers?organizationId=$organizationId';
    var url = '$mURL$cmd';
    try {
      List result = await _sendHttpGET(url);
      List<User> list = [];
      result.forEach((m) {
        list.add(User.fromJson(m));
      });
      await LocalDBAPI.addUsers(users: list);
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Project>> findProjectsByOrganization(
      String organizationId) async {
    pp('🍏 🍏 🍏 DataAPI: findProjectsByOrganization: 🍏 id: $organizationId');
    String? mURL = await getUrl();
    var cmd = 'findProjectsByOrganization';
    var url = '$mURL$cmd?organizationId=$organizationId';
    try {
      List result = await _sendHttpGET(url);
      pp('🍏 🍏 🍏 DataAPI: findProjectsByOrganization: 🍏 result: ${result.length} projects');
      List<Project> list = [];
      result.forEach((m) {
        list.add(Project.fromJson(m));
      });
      return list;
    } catch (e) {
      pp('Houston, 😈😈😈😈😈 we have a problem! 😈😈😈😈😈 $e');
      print(e);
      throw e;
    }
  }

  static Future<List<Photo>> getOrganizationPhotos(
      String organizationId) async {
    pp('🍏 🍏 🍏 DataAPI: getOrganizationPhotos: 🍏 id: $organizationId');
    String? mURL = await getUrl();
    var cmd = 'getOrganizationPhotos';
    var url = '$mURL$cmd?organizationId=$organizationId';
    try {
      List result = await _sendHttpGET(url);
      pp('🍏 🍏 🍏 DataAPI: getOrganizationPhotos: 🍏 found: ${result.length} org photos');
      List<Photo> list = [];
      result.forEach((m) {
        list.add(Photo.fromJson(m));
      });
      return list;
    } catch (e) {
      pp('Houston, 😈😈😈😈😈 we have a problem! 😈😈😈😈😈');
      print(e);
      throw e;
    }
  }

  static Future<List<Video>> getOrganizationVideos(
      String organizationId) async {
    pp('🍏 🍏 🍏 DataAPI: getOrganizationVideos: 🍏 id: $organizationId');
    String? mURL = await getUrl();
    var cmd = 'getOrganizationVideos';
    var url = '$mURL$cmd?organizationId=$organizationId';
    try {
      List result = await _sendHttpGET(url);
      List<Video> list = [];
      result.forEach((m) {
        list.add(Video.fromJson(m));
      });
      return list;
    } catch (e) {
      pp('Houston, 😈😈😈😈😈 we have a problem! 😈😈😈😈😈');
      print(e);
      throw e;
    }
  }

  static Future<List<Project>> findProjectsByLocation(
      {required double latitude, required double longitude, required double radiusInKM}) async {
    pp('🍏 🍏 🍏 DataAPI: findProjectsByLocation: 🍏 radiusInKM: $radiusInKM');
    String? mURL = await getUrl();
    var cmd = 'findProjectsByLocation';
    var url =
        '$mURL$cmd?latitude=$latitude&longitude=$longitude&radiusInKM=$radiusInKM';
    try {
      List result = await _sendHttpGET(url);
      List<Project> list = [];
      result.forEach((m) {
        list.add(Project.fromJson(m));
      });
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<City>> findCitiesByLocation(
      {required double latitude, required double longitude, required double radiusInKM}) async {
    pp('🍏 🍏 🍏 DataAPI: findCitiesByLocation: 🍏 radiusInKM: $radiusInKM');
    String? mURL = await getUrl();
    var cmd = 'findCitiesByLocation';
    var url =
        '$mURL$cmd?latitude=$latitude&longitude=$longitude&radiusInKM=$radiusInKM';
    try {
      List result = await _sendHttpGET(url);
      List<City> list = [];
      result.forEach((m) {
        list.add(City.fromJson(m));
      });
      pp('🍏 🍏 🍏 DataAPI: findCitiesByLocation: 🍏 found: ${list.length} cities');
      return list;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Questionnaire>> getQuestionnairesByOrganization(
      String organizationId) async {
    pp('🍏 🍏 🍏 DataAPI: getQuestionnairesByOrganization: 🍏 id: $organizationId');
    String? mURL = await getUrl();
    var cmd = 'getQuestionnairesByOrganization?organizationId=$organizationId';
    var url = '$mURL$cmd';
    try {
      List result = await _sendHttpGET(url);
      List<Questionnaire> list = [];
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
    String? mURL = await getUrl();
    Map bag = settlement.toJson();
    try {
      var result = await _callWebAPIPost(mURL! + 'updateSettlement', bag);
      return Community.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Community> addSettlement(Community settlement) async {
    String? mURL = await getUrl();
    Map bag = settlement.toJson();
    try {
      var result = await _callWebAPIPost(mURL! + 'addSettlement', bag);
      return Community.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future addPointToPolygon(
      {required String settlementId,
      required double latitude,
      required double longitude}) async {
    String? mURL = await getUrl();
    Map bag = {
      'settlementId': settlementId,
      'latitude': latitude,
      'longitude': longitude,
    };
    try {
      var result = await _callWebAPIPost(mURL! + 'addPointToPolygon', bag);
      return result;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future addQuestionnaireSection(
      {required String questionnaireId, required Section section}) async {
    String? mURL = await getUrl();
    Map bag = {
      'questionnaireId': questionnaireId,
      'section': section.toJson(),
    };
    try {
      var result = await _callWebAPIPost(mURL! + 'addQuestionnaireSection', bag);
      return result;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Community>> findCommunitiesByCountry(
      String countryId) async {
    String? mURL = await getUrl();

    pp('🍏🍏🍏🍏 ..... findCommunitiesByCountry ');
    var cmd = 'findCommunitiesByCountry';
    var url = '$mURL$cmd?countryId=$countryId';

    List result = await _sendHttpGET(url);
    List<Community> communityList = [];
    result.forEach((m) {
      communityList.add(Community.fromJson(m));
    });
    pp('🍏 🍏 🍏 findCommunitiesByCountry found ${communityList.length}');
    return communityList;
  }

  static Future<Project> addProject(Project project) async {
    String? mURL = await getUrl();
    Map bag = project.toJson();
    try {
      var result = await _callWebAPIPost(mURL! + 'addProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Project> updateProject(Project project) async {
    String? mURL = await getUrl();
    Map bag = project.toJson();
    try {
      var result = await _callWebAPIPost(mURL! + 'updateProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Project> addSettlementToProject(
      {required String projectId, required String settlementId}) async {
    String? mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
      'settlementId': settlementId,
    };
    try {
      var result = await _callWebAPIPost(mURL! + 'addSettlementToProject', bag);
      return Project.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<ProjectPosition> addProjectPosition(
      {required ProjectPosition position}) async {
    String? mURL = await getUrl();
    Map bag = position.toJson();
    try {
      var result = await _callWebAPIPost(mURL! + 'addProjectPosition', bag);
      return ProjectPosition.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future addPhoto(Photo photo) async {
    String? mURL = await getUrl();
    try {
      var result = await _callWebAPIPost(mURL! + 'addPhoto', photo.toJson());
      return result;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future addVideo(Video video) async {
    String? mURL = await getUrl();

    try {
      var result = await _callWebAPIPost(mURL! + 'addVideo', video.toJson());
      pp(result);
      return result;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future addCondition(Condition condition) async {
    String? mURL = await getUrl();

    try {
      var result = await _callWebAPIPost(mURL! + 'addVideo', condition.toJson());
      pp(result);
      return result;
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Community> addSettlementPhoto(
      {required String settlementId,
        required String url,
        required String comment,
        required double latitude,
      longitude,
        required String userId}) async {
    String? mURL = await getUrl();
    Map bag = {
      'settlementId': settlementId,
      'url': url,
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
    };
    try {
      var result = await _callWebAPIPost(mURL! + 'addSettlementPhoto', bag);
      return Community.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Project> addProjectVideo(
      {required String projectId,
        required String url,
        required String comment,
        required double latitude,
      longitude,
        required String userId}) async {
    String? mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
      'url': url,
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId
    };
    try {
      var result = await _callWebAPIPost(mURL! + 'addProjectVideo', bag);
      return Project.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Project> addProjectRating(
      {required String projectId,
        required String rating,
        required String comment,
        required double latitude,
      longitude,
        required String userId}) async {
    String? mURL = await getUrl();
    Map bag = {
      'projectId': projectId,
      'rating': rating,
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId
    };
    try {
      var result = await _callWebAPIPost(mURL! + 'addProjectRating', bag);
      return Project.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<Questionnaire> addQuestionnaire(
      Questionnaire questionnaire) async {
    String? mURL = await getUrl();
    Map bag = questionnaire.toJson();
    prettyPrint(bag,
        'DataAPI  💦 💦 💦 addQuestionnaire: 🔆🔆 Sending to web api ......');
    try {
      var result = await _callWebAPIPost(mURL! + 'addQuestionnaire', bag);
      return Questionnaire.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Project>> findAllProjects(String organizationId) async {
    String? mURL = await getUrl();
    Map bag = {};
    try {
      List result = await _callWebAPIPost(mURL! + 'findAllProjects', bag);
      List<Project> list = [];
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
    String? mURL = await getUrl();
    Map bag = org.toJson();

    pp('DataAPI_addOrganization:  🍐 org Bag to be sent, check properties:  🍐 $bag');
    try {
      var result = await _callWebAPIPost(mURL! + 'addOrganization', bag);
      return Organization.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<OrgMessage> sendMessage(OrgMessage message) async {
    String? mURL = await getUrl();
    Map bag = message.toJson();

    pp('DataAPI_sendMessage:  🍐 org message to be sent, check properties:  🍐 $bag');
    try {
      var result = await _callWebAPIPost(mURL! + 'sendMessage', bag);
      return OrgMessage.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<User?> findUserByEmail(String email) async {
    pp('🐤🐤🐤🐤 DataAPI : ... findUserByEmail $email ');
    String? mURL = await getUrl();
    assert(mURL != null);
    var command = "findUserByEmail?email=$email";

    try {
      pp('🐤🐤🐤🐤 DataAPI : ... 🥏 calling _callWebAPIPost .. 🥏 findUserByEmail $mURL$command ');
      var result = await _sendHttpGET(
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
    String? mURL = await getUrl();
    Map bag = {
      'uid': uid,
    };
    try {
      var result = await _callWebAPIPost(mURL! + 'findUserByUid', bag);
      return User.fromJson(result);
    } catch (e) {
      pp(e);
      throw e;
    }
  }

  static Future<List<Country>> getCountries() async {
    String? mURL = await getUrl();
    var cmd = 'getCountries';
    var url = '$mURL$cmd';
    try {
      List result = await _sendHttpGET(url);
      List<Country> list = [];
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
    String? mURL = await getUrl();
    var result = await _sendHttpGET(mURL!);
    pp('DataAPI: 🔴 🔴 🔴 hello: $result');
  }

  static Future ping() async {
    String? mURL = await getUrl();
    var result = await _sendHttpGET(mURL! + 'ping');
    pp('DataAPI: 🔴 🔴 🔴 ping: $result');
  }

  static Future _callWebAPIPost(String mUrl, Map bag) async {
    pp('$xz http POST call: 🔆 🔆 🔆  calling : 💙  $mUrl  💙 ');

    var mBag;
    if (bag != null) {
      mBag = json.encode(bag);
    }
    pp('$xz http POST call: Bag after json decode call, check properties of mBag:  🏈 🏈 $mBag');
    var start = DateTime.now();
    var client = new http.Client();
    var token = await AppAuth.getAuthToken();
    pp('$xz http POST call: 😡 😡 😡Firebase auth token: ❤️ $token ❤️');
    headers['Authorization'] = 'Bearer $token';
    pp('$xz http POST call: 😡 😡 😡 check the headers for the auth token: 💙 💙 💙 $headers 💙 💙 💙 ');
    var resp = await client
        .post(
          Uri.parse(mUrl),
          body: mBag,
          headers: headers,
        )
        .whenComplete(() {});
    if (resp.statusCode == 200) {
      pp('$xz http POST call RESPONSE: 💙💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
    } else {
      pp('👿👿👿 DataAPI._callWebAPIPost: 🔆 statusCode: 👿👿👿 ${resp.statusCode} 🔆🔆🔆 for $mUrl');
      throw Exception(
          '🚨 🚨 Status Code 🚨 ${resp.statusCode} 🚨 ${resp.body}');
    }
    var end = DateTime.now();
    pp('$xz http POST call: 🔆 elapsed time: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
    pp(resp.body);
    try {
      var mJson = json.decode(resp.body);
      return mJson;
    } catch (e) {
      pp("👿👿👿👿👿👿👿 json.decode failed, returning response body");
      return resp.body;
    }
  }

  static const xz = '🌎 🌎 🌎 🌎 🌎 🌎 DataAPI: ';
  static Future _sendHttpGET(String mUrl) async {
    pp('$xz http GET call:  🔆 🔆 🔆 calling : 💙  $mUrl  💙');
    var start = DateTime.now();
    var client = new http.Client();
    var token = await AppAuth.getAuthToken();
    pp('$xz http GET call: 😡 😡 😡 Firebase Auth Token: 💙️ $token 💙');
    headers['Authorization'] = 'Bearer $token';

    pp('$xz http GET call: 😡 😡 😡 check the headers for the auth token: 💙 💙 💙 $headers 💙 💙 💙 ');
    var resp = await client
        .get(
          Uri.parse(mUrl),
          headers: headers,
        )
        .whenComplete(() {})
        .onError((error, stackTrace) {
      var msg = 'We are fucked without benefit of vaseline!';
      pp(' $msg ');
      throw Exception('$xz $msg : $error');
    });

    pp('$xz http GET call RESPONSE: .... : 💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
    var end = DateTime.now();
    pp('$xz http GET call: 🔆 elapsed time for http: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
    sendError(resp);
    var mJson = json.decode(resp.body);
    return mJson;
  }

  static void sendError(http.Response resp) {
    if (resp.statusCode != 200) {
      var msg =
          '😡 😡 The response is not 200; it is ${resp.statusCode}, NOT GOOD, throwing up !! 🥪 🥙 🌮  😡 ${resp.body}';
      pp(msg);
      throw Exception(msg);
    }
  }
}
