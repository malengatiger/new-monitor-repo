import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';



final AdminBloc adminBloc = AdminBloc();

class AdminBloc {
  StreamController<List<Settlement>> _settController =
      StreamController.broadcast();
  StreamController<List<Questionnaire>> _questController =
      StreamController.broadcast();
  StreamController<List<Project>> _projController =
      StreamController.broadcast();
  StreamController<List<Country>> _cntryController =
  StreamController.broadcast();

  Stream get settlementStream => _settController.stream;
  Stream get questionnaireStream => _questController.stream;
  Stream get projectStream => _projController.stream;
  Stream get countryStream => _cntryController.stream;

  StreamController<List<User>> _userController = StreamController.broadcast();
  List<Settlement> _settlements = List();
  List<Questionnaire> _questionnaires = List();
  List<Project> _projects = List();
  List<User> _users = List();
  List<Country> _countries = List();

  AdminBloc() {
    checkPermission();
  }


  Future<Position> getCurrentLocation()  async {
    var location = Location();
    try {
      var mLocation = await location.getLocation();
      return  Position.fromJson({
        'coordinates': [mLocation.longitude, mLocation.latitude],
        'type': 'Point',
      });
    }  catch (e) {
        throw Exception('Permission denied');
    }

  }
  Future checkPermission() async {
    print(' 🔆 🔆 🔆 🔆 checking permission ...');

    final Future<PermissionStatus> statusFuture =
    PermissionHandler().checkPermissionStatus(PermissionGroup.location);

    statusFuture.then((PermissionStatus status) {
     switch(status) {
       case PermissionStatus.granted:
         print('location is GRANTED:  ❤️ 🧡 💛 💚 💙 💜');
         break;
       case PermissionStatus.denied:
         print('location is DENIED 🔱 🔱 🔱 🔱 🔱 ');
         requestPermission();
         break;
       case PermissionStatus.disabled:
         print('location is DiSABLED  🔕 🔕 🔕 🔕 🔕 ');
         requestPermission();
         break;
       case PermissionStatus.unknown:
         print('location is UNKNOWN  🔕 🔕 🔕 🔕 🔕 ');
         requestPermission();
         break;
     }
    });

  }
  Future requestPermission() async {
    print('🧩🧩🧩🧩 Requesting permission ....  🧩🧩🧩🧩');
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    final List<PermissionGroup> permissions = <PermissionGroup>[PermissionGroup.location];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
    await PermissionHandler().requestPermissions(permissions);

    var permissionStatus = permissionRequestResult[permission];
    if (permissionStatus == PermissionStatus.granted) {
      print('💚💚💚💚 Permission has been  granted. 🍏🍏 Yeah!');
    }

  }
  Future addToPolygon({@required String settlementId, @required double latitude, @required double longitude}) async {
    var res = await DataAPI.addPointToPolygon(settlementId: settlementId, latitude: latitude, longitude: longitude);
    print(res);
    return res;
  }
  Future addSettlement(Settlement sett) async {
    var res = await DataAPI.addSettlement(sett);
    _settlements.add(res);
    _settController.sink.add(_settlements);
  }

  Future<List<Settlement>> findSettlementsByCountry(String countryId) async {
    _settlements.clear();
    var res = await DataAPI.findSettlementsByCountry(countryId);
    _settlements.addAll(res);
    _settController.sink.add(_settlements);
    print('adminBloc:  🧩 🧩 🧩 _settController.sink.added 🏈 🏈 ${_settlements.length} settlements  ');
    _settlements.forEach((s) {
      prettyPrint(s.toJson(), '🍏 🍏 🍏 SETTLEMENT 🍏 🍏 ');
    });
    return _settlements;
  }

  Future addQuestionnaire(Questionnaire quest) async {
    var res = await DataAPI.addQuestionnaire(quest);
    _questionnaires.add(res);
    _questController.sink.add(_questionnaires);
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

  Future addProject(Project project) async {
    var res = await DataAPI.addProject(project);
    _projects.add(res);
    _projController.sink.add(_projects);
  }

  close() {
    _settController.close();
    _questController.close();
    _projController.close();
    _userController.close();
    _cntryController.close();
  }
}
