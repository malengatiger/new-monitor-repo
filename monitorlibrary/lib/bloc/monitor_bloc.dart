import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/location/loc_bloc.dart';

final MonitorBloc monitorBloc = MonitorBloc();

class MonitorBloc {
  MonitorBloc() {
    _initialize();
  }

  User _user;
  User get user => _user;
  StreamController<List<Community>> _reportController =
      StreamController.broadcast();
  StreamController<List<User>> _userController = StreamController.broadcast();
  StreamController<List<Community>> _communityController =
      StreamController.broadcast();
  StreamController<List<Questionnaire>> _questController =
      StreamController.broadcast();
  StreamController<List<Project>> _projController =
      StreamController.broadcast();
  StreamController<List<Photo>> _photoController = StreamController.broadcast();
  StreamController<List<Video>> _videoController = StreamController.broadcast();
  StreamController<List<ProjectPosition>> _projPositionsController =
      StreamController.broadcast();
  StreamController<List<Country>> _countryController =
      StreamController.broadcast();

  StreamController<Questionnaire> _activeQuestionnaireController =
      StreamController.broadcast();
  StreamController<User> _activeUserController = StreamController.broadcast();

  Stream get reportStream => _reportController.stream;
  Stream get settlementStream => _communityController.stream;
  Stream get questionnaireStream => _questController.stream;
  Stream get projectStream => _projController.stream;
  Stream get projectPositionsStream => _projPositionsController.stream;
  Stream get countryStream => _countryController.stream;
  Stream get activeUserStream => _activeUserController.stream;
  Stream get usersStream => _userController.stream;
  Stream get activeQuestionnaireStream => _activeQuestionnaireController.stream;

  Stream get photoStream => _photoController.stream;
  Stream get videoStream => _videoController.stream;

  List<Community> _communities = List();
  List<Questionnaire> _questionnaires = List();
  List<Project> _projects = List();
  List<ProjectPosition> _projectPositions = List();
  List<Photo> _photos = List();
  List<Video> _videos = List();
  List<User> _users = List();
  List<Country> _countries = List();

  Future<List<Project>> getProjectsWithinRadius(
      {double radiusInKM = 100.5, bool checkUserOrg = true}) async {
    Position pos;
    try {
      pos = await locationBloc.getLocation();
      pp('💜 💜 💜 MonitorBloc: current location: 💜 latitude: ${pos.latitude} longitude: ${pos.longitude}');
    } catch (e) {
      pp('MonitorBloc: Location is fucked!');
      throw e;
    }
    var projects = await DataAPI.findProjectsByLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
        radiusInKM: radiusInKM);

    var userProjects = List<Project>();
    projects.forEach((project) {
      pp('💜 💜 COMPARING: 💜 💜 project.organizationId: ${project.organizationId} '
          '🍏 user.organizationId: ${user.organizationId}');
      if (project.organizationId == user.organizationId) {
        userProjects.add(project);
      }
    });

    pp('💜 💜 💜 MonitorBloc: Projects within radius of $radiusInKM kilometres; '
        'found: 💜 ${projects.length} projects');
    projects.forEach((project) {
      pp('😡  😡  😡  😡  PROJECT: ${project.name} 🍏 ${project.organizationName}  🍏 ${project.organizationId}');
    });
    pp('💜 💜 💜 MonitorBloc: User Org Projects within radius of $radiusInKM kilometres; '
        'found: 💜 ${userProjects.length} projects');
    userProjects.forEach((proj) {
      pp('💜 💜 PROJECT: ${proj.name} 🍏 ${proj.organizationName}  🍏 ${proj.organizationId}');
    });
    if (checkUserOrg) {
      return userProjects;
    } else {
      return projects;
    }
  }

  Future<List<Project>> getOrganizationProjects({String organizationId}) async {
    pp('💜 💜 💜 MonitorBloc: getOrganizationProjects: for organizationId: $organizationId ; '
        'user: 💜 ${user.name} user.organizationId: ${user.organizationId} user.organizationName: ${user.organizationName} ');
    _projects = await DataAPI.findProjectsByOrganization(organizationId);
    _projController.sink.add(_projects);
    pp('💜 💜 💜 MonitorBloc: OrganizationProjects found: 💜 ${_projects.length} projects ');
    _projects.forEach((project) {
      pp('💜 💜 PROJECT: ${project.name} 🍏 ${project.organizationName}  🍏 ${project.organizationId}');
    });
    return _projects;
  }

  Future<List<User>> getOrganizationUsers({String organizationId}) async {
    _users = await DataAPI.findUsersByOrganization(organizationId);
    _userController.sink.add(_users);
    pp('💜 💜 💜 MonitorBloc: getOrganizationUsers found: 💜 ${_users.length} users ');
    _users.forEach((element) {
      pp('😲 😡  USER: ${element.name} 🍏 ${element.organizationName}');
    });
    return _users;
  }

  Future<List<ProjectPosition>> getProjectPositions({String projectId}) async {
    _projectPositions = await DataAPI.findProjectPositionsById(projectId);
    _projPositionsController.sink.add(_projectPositions);
    pp('💜 💜 💜 MonitorBloc: getProjectPositions found: 💜 ${_projectPositions.length} projectPositions ');
    return _projectPositions;
  }

  Future<List<Photo>> getProjectPhotos({String projectId}) async {
    _photos = await DataAPI.findPhotosByProject(projectId);
    _photoController.sink.add(_photos);
    pp('💜 💜 💜 MonitorBloc: getProjectPhotos found: 💜 ${_photos.length} photos ');
    return _photos;
  }

  Future<List<Photo>> getOrganizationPhotos({String organizationId}) async {
    await getOrganizationProjects(organizationId: organizationId);
    for (var i = 0; i < _projects.length; i++) {
      var photos =
          await DataAPI.findPhotosByProject(_projects.elementAt(i).projectId);
      _photos.addAll(photos);
    }

    _photoController.sink.add(_photos);
    pp('💜 💜 💜 MonitorBloc: getOrganizationPhotos found: 💜 ${_photos.length} photos ');
    return _photos;
  }

  Future<List<Video>> getOrganizationVideos({String organizationId}) async {
    await getOrganizationProjects(organizationId: organizationId);
    for (var i = 0; i < _projects.length; i++) {
      var videos =
          await DataAPI.findVideosById(_projects.elementAt(i).projectId);
      _videos.addAll(videos);
    }

    _videoController.sink.add(_videos);
    pp('💜 💜 💜 MonitorBloc: getOrganizationVideos found: 💜 ${_videos.length} videos ');
    return _videos;
  }

  Future<List<Video>> getProjectVideos({String projectId}) async {
    _videos = await DataAPI.findVideosById(projectId);
    _videoController.sink.add(_videos);
    pp('💜 💜 💜 MonitorBloc: getProjectVideos found: 💜 ${_videos.length} videos ');
    return _videos;
  }

  void _initialize() async {
    pp('🏈🏈🏈🏈🏈 Initializing MonitorBloc ....');
    _user = await Prefs.getUser();
  }

  close() {
    _communityController.close();
    _questController.close();
    _projController.close();
    _userController.close();
    _countryController.close();
    _activeQuestionnaireController.close();
    _activeUserController.close();
    _reportController.close();
    _projPositionsController.close();

    _videoController.close();
    _photoController.close();
  }
}
