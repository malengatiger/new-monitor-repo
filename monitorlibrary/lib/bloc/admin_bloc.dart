import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/position.dart' as mon;
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/section.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/location/loc_bloc.dart';

final AdminBloc bloc = AdminBloc();

class AdminBloc {
  StreamController<List<Community>> _settController =
      StreamController.broadcast();
  StreamController<List<Questionnaire>> _questController =
      StreamController.broadcast();
  StreamController<List<Project>> _projController =
      StreamController.broadcast();
  StreamController<List<Country>> _cntryController =
      StreamController.broadcast();
  StreamController<Questionnaire> _activeQuestionnaireController =
      StreamController.broadcast();
  StreamController<User> _activeUserController = StreamController.broadcast();

  Stream get settlementStream => _settController.stream;
  Stream get questionnaireStream => _questController.stream;
  Stream get projectStream => _projController.stream;
  Stream get countryStream => _cntryController.stream;
  Stream get activeUserStream => _activeUserController.stream;
  Stream get usersStream => _userController.stream;
  Stream get activeQuestionnaireStream => _activeQuestionnaireController.stream;

  StreamController<List<User>> _userController = StreamController.broadcast();
  List<Community> _communities = List();
  List<Questionnaire> _questionnaires = List();
  List<Project> _projects = List();
  List<User> _users = List();
  List<Country> _countries = List();

  GeneralBloc() {
    checkPermission();
    _setActiveQuestionnaire();
    setActiveUser();
  }

  setActiveUser() async {
    var user = await Prefs.getUser();
    if (user != null) {
      pp('setting active user .... 🤟🤟');
      _activeUserController.sink.add(user);
    }
  }

  _setActiveQuestionnaire() async {
    var q = await Prefs.getQuestionnaire();
    if (q != null) {
      updateActiveQuestionnaire(q);
    }
  }

  updateActiveQuestionnaire(Questionnaire q) {
    _activeQuestionnaireController.sink.add(q);
    pp('🍅 🍅 🍅 🍅 active questionnaire has been set');
    prettyPrint(
        q.toJson(), '🅿️ 🅿️ 🅿️ 🅿️ 🅿️ ACTIVE QUESTIONNAIRE 🍅 🍅 🍅 🍅 ');
  }

  Future<mon.Position> getCurrentPosition() async {
    try {
      var mLocation = await locationBloc.getLocation();
      return mon.Position.fromJson({
        'coordinates': [mLocation.longitude, mLocation.latitude],
        'type': 'Point',
      });
    } catch (e) {
      throw Exception('Permission denied');
    }
  }

  Future checkPermission() async {
    pp(' 🔆 🔆 🔆 🔆 .................... checking permissions 💙 location 💙 storage ?? 💙 ...');
    return locationBloc.checkPermission();
  }

  Future addToPolygon(
      {@required String settlementId,
      @required double latitude,
      @required double longitude}) async {
    var res = await DataAPI.addPointToPolygon(
        settlementId: settlementId, latitude: latitude, longitude: longitude);
    pp('Bloc: 🐬 🐬 addToPolygon ... check response below');

    var country = await Prefs.getCountry();
    if (country != null) {
      pp('Bloc: 🐬 🐬 addToPolygon ... 🐷 🐷 🐷 refreshing settlement list');
//      _settlements = await findSettlementsByCountry(country.countryId);
//      _settController.sink.add(_settlements);
    }
    return res;
  }

  Future addQuestionnaireSection(
      {@required String questionnaireId, @required Section section}) async {
    var res = await DataAPI.addQuestionnaireSection(
        questionnaireId: questionnaireId, section: section);
    var user = await Prefs.getUser();
    if (user != null) {
      await getQuestionnairesByOrganization(user.organizationId);
      pp('🤟🤟🤟 Org questionnaires refreshed 🌹');
    }

    return res;
  }

  Future addCommunity(Community sett) async {
    var res = await DataAPI.addSettlement(sett);
    _communities.add(res);
    _settController.sink.add(_communities);
    await findCommunitiesByCountry(sett.countryId);
  }

  Future updateCommunity(Community sett) async {
    var res = await DataAPI.updateSettlement(sett);
    _communities.add(res);
    _settController.sink.add(_communities);
    await findCommunitiesByCountry(sett.countryId);
  }

  Future<List<Community>> findCommunitiesByCountry(String countryId) async {
    _communities.clear();
    var res = await DataAPI.findCommunitiesByCountry(countryId);
    _communities.addAll(res);
    _settController.sink.add(_communities);
    pp('adminBloc:  🧩 🧩 🧩 _settController.sink.added 🏈 🏈 ${_communities.length} settlements  ');
    return _communities;
  }

  Future addQuestionnaire(Questionnaire quest) async {
    var res = await DataAPI.addQuestionnaire(quest);
    _questionnaires.add(res);
    _questController.sink.add(_questionnaires);

    var user = await Prefs.getUser();
    if (user != null) {
      await getQuestionnairesByOrganization(user.organizationId);
      pp('🤟🤟🤟 Org questionnaires refreshed after 🤟 successfull addition to DB 🌹');
    }
  }

  Future<List<Questionnaire>> getQuestionnairesByOrganization(
      String organizationId) async {
    _questionnaires.clear();
    var res = await DataAPI.getQuestionnairesByOrganization(organizationId);
    _questionnaires.addAll(res);
    _questController.sink.add(_questionnaires);
    return _questionnaires;
  }

  Future<List<Country>> getCountries() async {
    _countries.clear();
    var res = await DataAPI.getCountries();
    _countries.addAll(res);
    _cntryController.sink.add(_countries);
    return _countries;
  }

  Future addUser(User user) async {
    var res = await DataAPI.addUser(user);
    _users.add(res);
    _userController.sink.add(_users);
  }

  Future<List<User>> findUsersByOrganization(String organizationId) async {
    _users.clear();
    var res = await DataAPI.findUsersByOrganization(organizationId);
    _users.addAll(res);
    _userController.sink.add(_users);
    return _users;
  }

  Future<List<Project>> findProjectsByOrganization(
      String organizationId) async {
    _projects.clear();
    var res = await DataAPI.findProjectsByOrganization(organizationId);
    _projects.addAll(res);
    _projController.sink.add(_projects);
    return _projects;
  }

  Future<Project> findProjectById(String projectId) async {
    var res = await DataAPI.findProjectById(projectId);
    prettyPrint(res.toJson(), '❤️ 🧡 💛 RESULT: findProjectById: ❤️ 🧡 💛');
    pp('\n\n❤️ 🧡 💛');
    return res;
  }

  Future<Project> addProject(Project project) async {
    var res = await DataAPI.addProject(project);
    pp('🎽 🎽 🎽 Bloc: addProject: Project adding to stream ...');
    _projects.add(res);
    _projController.sink.add(_projects);
    findProjectsByOrganization(project.organizationId);
    return res;
  }

  close() {
    _settController.close();
    _questController.close();
    _projController.close();
    _userController.close();
    _cntryController.close();
    _activeQuestionnaireController.close();
    _activeUserController.close();
  }
}
