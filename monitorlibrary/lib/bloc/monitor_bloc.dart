import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/local_mongo.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/field_monitor_schedule.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/location/loc_bloc.dart';
import 'package:universal_platform/universal_platform.dart';

final MonitorBloc monitorBloc = MonitorBloc();

class MonitorBloc {
  MonitorBloc() {
    _initialize();
  }

  User? _user;

  User get user => _user!;
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

  StreamController<List<Photo>> _projectPhotoController =
      StreamController.broadcast();
  StreamController<List<Video>> _projectVideoController =
      StreamController.broadcast();

  StreamController<List<ProjectPosition>> _projPositionsController =
      StreamController.broadcast();
  StreamController<List<FieldMonitorSchedule>> _fieldMonitorScheduleController =
      StreamController.broadcast();
  StreamController<List<Country>> _countryController =
      StreamController.broadcast();

  StreamController<Questionnaire> _activeQuestionnaireController =
      StreamController.broadcast();
  StreamController<User> _activeUserController = StreamController.broadcast();

  Stream<List<Photo>> get projectPhotoStream => _projectPhotoController.stream;

  Stream<List<Video>> get projectVideoStream => _projectVideoController.stream;

  Stream get reportStream => _reportController.stream;

  Stream get settlementStream => _communityController.stream;

  Stream get questionnaireStream => _questController.stream;

  Stream<List<Project>> get projectStream => _projController.stream;

  Stream get projectPositionsStream => _projPositionsController.stream;

  Stream get countryStream => _countryController.stream;

  Stream get activeUserStream => _activeUserController.stream;

  Stream<List<User>> get usersStream => _userController.stream;

  Stream get activeQuestionnaireStream => _activeQuestionnaireController.stream;

  Stream get fieldMonitorScheduleStream =>
      _fieldMonitorScheduleController.stream;

  Stream<List<Photo>> get photoStream => _photoController.stream;

  Stream<List<Video>> get videoStream => _videoController.stream;

  List<Community> _communities = [];
  List<Questionnaire> _questionnaires = [];
  List<Project> _projects = [];
  List<ProjectPosition> _projectPositions = [];
  List<Photo> _photos = [];
  List<Video> _videos = [];
  List<User> _users = [];
  List<Country> _countries = [];
  List<FieldMonitorSchedule> _schedules = [];

  Future<List<Project>> getProjectsWithinRadius(
      {double radiusInKM = 100.5, bool checkUserOrg = true}) async {
    Position pos;
    try {
      if (_user == null) {
        _user = await Prefs.getUser();
      }
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

    List<Project> userProjects = [];

    pp('🍏 🍏 🍏 MonitorBloc: Projects within radius of  🍏 $radiusInKM  🍏 kilometres; '
        'found: 💜 ${projects.length} projects');
    projects.forEach((project) {
      pp('😡 😡 😡 ALL PROJECT found in radius: ${project.name} 🍏 ${project.organizationName}  🍏 ${project.organizationId}');
      if (project.organizationId == _user!.organizationId) {
        userProjects.add(project);
      }
    });

    pp('💜 💜 💜 MonitorBloc: User Org Projects within radius of $radiusInKM kilometres; '
        'found: 💜 ${userProjects.length} projects in organization, filtered out non-org projects found in radius');
    userProjects.forEach((proj) {
      pp('💜 💜 💜 user PROJECT: ${proj.name} 🍏 ${proj.organizationName}  🍏 ${proj.organizationId}');
    });
    if (checkUserOrg) {
      return userProjects;
    } else {
      return projects;
    }
  }

  Future<List<Project>> getOrganizationProjects(
      {required String organizationId, required bool forceRefresh}) async {
    try {
      if (_user == null) {
        _user = await Prefs.getUser();
      }
      pp(
          '💜 💜 💜 💜 MonitorBloc: getOrganizationProjects: for organizationId: $organizationId ; '
              'user: 💜 ${user.name} user.organizationId: ${user
              .organizationId} user.organizationName: ${user
              .organizationName} ');

      _projects = await LocalMongo.getProjects();

      if (_projects.isEmpty || forceRefresh) {
        _projects = await DataAPI.findProjectsByOrganization(organizationId);
        await LocalMongo.addProjects(projects: _projects);
      }
      _projController.sink.add(_projects);
      pp('💜 💜 💜 💜 MonitorBloc: OrganizationProjects found: 💜 ${_projects
          .length} projects 💜');
      _projects.forEach((project) {
        pp('💜 💜 💜 💜 Org PROJECT: ${project.name} 🍏 ${project
            .organizationName}  🍏 ${project.organizationId}');
      });
    } catch (e) {
      pp('$mm $e');
    }

    return _projects;
  }

  Future refreshOrgDashboardData({required bool forceRefresh}) async {
    if (_user == null) {
      _user = await Prefs.getUser();
    }
    pp('$mm MonitorBloc:refreshDashboardData .... forceRefresh: $forceRefresh 💜 💜 💜 💜 💜 💜');
    await getOrganizationUsers(
        organizationId: _user!.organizationId!, forceRefresh: forceRefresh);
    await getOrganizationProjects(
        organizationId: _user!.organizationId!, forceRefresh: forceRefresh);
    await getOrganizationPhotos(
        organizationId: _user!.organizationId!, forceRefresh: forceRefresh);
    await getOrganizationVideos(
        organizationId: _user!.organizationId!, forceRefresh: forceRefresh);
    await getOrgFieldMonitorSchedules(
        organizationId: _user!.organizationId!, forceRefresh: forceRefresh);
  }
  static const mm = '💜 💜 💜 💜 💜 💜 MonitorBloc 💜 💜 ';

  Future<List<User>> getOrganizationUsers(
      {required String organizationId, required bool forceRefresh}) async {
    pp('$mm getOrganizationUsers ... forceRefresh: $forceRefresh');
    _users = await LocalMongo.getUsers();

    if (_users.isEmpty || forceRefresh) {
      _users = await DataAPI.findUsersByOrganization(organizationId);
      pp('$mm getOrganizationUsers ... _users: ${_users.length} ... will add to cache');
      await LocalMongo.addUsers(users: _users);
    }
    pp('$mm getOrganizationUsers found: 💜 ${_users.length} users. adding to stream ... ');
    _userController.sink.add(_users);

    _users.forEach((element) {
      pp('$mm 😲 😡 USER:  🍏 ${element.name} 🍏 ${element.organizationName}');
    });

    return _users;
  }

  Future<List<ProjectPosition>> getProjectPositions(
      {required String projectId, required bool forceRefresh}) async {

    _projectPositions = await LocalMongo.getProjectPositions(projectId);
    pp('$mm getProjectPositions found ${_projectPositions.length} positions in local cache ');

    if (_projectPositions.isEmpty || forceRefresh) {
      _projectPositions = await DataAPI.findProjectPositionsById(projectId);
      pp('$mm getProjectPositions found ${_projectPositions.length} positions from remote database ');
      await LocalMongo.addProjectPositions(positions: _projectPositions);
    }
    _projPositionsController.sink.add(_projectPositions);
    pp('$mm getProjectPositions found: 💜 ${_projectPositions.length} projectPositions from local or remote db ');
    return _projectPositions;
  }

  Future<List<Photo>> getProjectPhotos(
      {required String projectId, required bool forceRefresh }) async {
    List<Photo> photos = [];

    photos = await LocalMongo.getProjectPhotos(projectId);

    if (photos.isEmpty || forceRefresh) {
      photos = await DataAPI.findPhotosByProject(projectId);
      await LocalMongo.addPhotos(photos: photos);
    }
    _projectPhotoController.sink.add(photos);
    pp('💜 💜 💜 MonitorBloc: getProjectPhotos found: 💜 ${photos.length} photos ');

    return photos;
  }

  Future<List<FieldMonitorSchedule>> getProjectFieldMonitorSchedules(
      {required String projectId, required bool forceRefresh}) async {
    _schedules = await LocalMongo.getProjectMonitorSchedules(projectId);

    if (_schedules.isEmpty || forceRefresh) {
      _schedules = await DataAPI.getProjectFieldMonitorSchedules(projectId);
      await LocalMongo.addFieldMonitorSchedules(schedules: _schedules);
    }
    var m = filterSchedulesByProject(_schedules);
    _schedules = m;
    _fieldMonitorScheduleController.sink.add(_schedules);
    pp('🔵 🔵 🔵  MonitorBloc: getProjectFieldMonitorSchedules found: 💜 ${_schedules.length} schedules ');

    return _schedules;
  }

  Future<List<FieldMonitorSchedule>> getMonitorFieldMonitorSchedules(
      {required String userId, required bool forceRefresh}) async {
    _schedules = await LocalMongo.getFieldMonitorSchedules(userId);

    if (_schedules.isEmpty || forceRefresh) {
      _schedules = await DataAPI.getMonitorFieldMonitorSchedules(userId);
      await LocalMongo.addFieldMonitorSchedules(schedules: _schedules);
    }
    _schedules.sort((a, b) => b.date!.compareTo(a.date!));
    var m = filterSchedulesByProject(_schedules);
    _schedules = m;
    _fieldMonitorScheduleController.sink.add(_schedules);
    pp('🔵 🔵 🔵  MonitorBloc: getMonitorFieldMonitorSchedules found: 💜 ${_schedules.length} schedules ');

    _schedules.forEach((element) {});
    return _schedules;
  }

  static List<FieldMonitorSchedule> filterSchedulesByProject(
      List<FieldMonitorSchedule> mList) {
    pp('🔵 🔵 🔵  MonitorBloc: filterSchedulesByProject: 🦠 filter ${mList.length} schedules by projectId');
    mList.forEach((element) {
      pp('PreFilter: Schedule: ${element.toJson()}');
    });
    //todo - filter latest by project

    Map<String, FieldMonitorSchedule> map = Map();
    mList.sort((a, b) => b.date!.compareTo(a.date!));
    mList.forEach((element) {
      if (!map.containsKey(element.projectId)) {
        map['${element.projectId}'] = element;
      }
    });
    mList = map.values.toList();
    mList.forEach((element) {
      pp('PostFilter: Schedule: ${element.toJson()}');
    });
    return mList;
  }

  Future<List<FieldMonitorSchedule>> getOrgFieldMonitorSchedules(
      {required String organizationId, required bool forceRefresh}) async {
    _schedules =
        await LocalMongo.getOrganizationMonitorSchedules(organizationId);

    if (_schedules.isEmpty || forceRefresh) {
      _schedules = await DataAPI.getOrgFieldMonitorSchedules(organizationId);
      await LocalMongo.addFieldMonitorSchedules(schedules: _schedules);
    }
    var m = filterSchedulesByProject(_schedules);
    _schedules = m;
    _fieldMonitorScheduleController.sink.add(_schedules);
    pp('🔵 🔵 🔵 MonitorBloc: getOrgFieldMonitorSchedules found: 🔵 ${_schedules.length} schedules ');

    return _schedules;
  }

  Future<List<Photo>> getOrganizationPhotos(
      {required String organizationId, required bool forceRefresh}) async {
    try {
      var android = UniversalPlatform.isAndroid;
      if (android) {
        _photos = await LocalMongo.getPhotos();
      } else {
        _photos.clear();
      }

      if (_photos.isEmpty || forceRefresh) {
        _photos = await DataAPI.getOrganizationPhotos(organizationId);
        if (android) await LocalMongo.addPhotos(photos: _photos);
      }
      _photoController.sink.add(_photos);
      pp('💜 💜 💜 MonitorBloc: getOrganizationPhotos found: 💜 ${_photos.length} photos 💜 ');
    } catch (e) {
      pp('😈😈😈😈😈 MonitorBloc: getOrganizationPhotos FAILED: 😈😈😈😈😈 $e');
      throw e;
    }

    return _photos;
  }

  Future<List<Video>> getOrganizationVideos(
      {required String organizationId, required bool forceRefresh}) async {
    try {
      var android = UniversalPlatform.isAndroid;
      if (android) {
        _videos = await LocalMongo.getVideos();
      } else {
        _videos.clear();
      }
      if (_videos.isEmpty || forceRefresh) {
        _videos = await DataAPI.getOrganizationVideos(organizationId);
        if (android) await LocalMongo.addVideos(videos: _videos);
      }
      _videoController.sink.add(_videos);
      pp('💜 💜 💜 MonitorBloc: getOrganizationVideos found: 💜 ${_videos.length} videos ');
    } catch (e) {
      pp('💜 💜 💜 MonitorBloc: getOrganizationVideos FAILED');
      throw e;
    }

    return _videos;
  }

  Future<List<Video>> getProjectVideos(
      {required String projectId, required bool forceRefresh}) async {
    List<Video> videos = [];
    var android = UniversalPlatform.isAndroid;
    if (android) {
      videos = await LocalMongo.getProjectVideos(projectId);
    }
    if (videos.isEmpty || forceRefresh) {
      videos = await DataAPI.findVideosById(projectId);
      if (android) await LocalMongo.addVideos(videos: videos);
    }
    _projectVideoController.sink.add(videos);
    pp('💜 💜 💜 MonitorBloc: getProjectVideos found: 💜 ${videos.length} videos ');

    return videos;
  }

  Future refreshProjectData({required String projectId, required bool forceRefresh}) async {
    pp('$mm refreshing project data ... photos, videos and schedules ...');
    await getProjectPhotos(projectId: projectId, forceRefresh: forceRefresh);
    await getProjectVideos(projectId: projectId, forceRefresh: forceRefresh);
    await getProjectFieldMonitorSchedules(
        projectId: projectId, forceRefresh: forceRefresh);
    return null;
  }

  Future<List<Photo>> getUserProjectPhotos(
      {required String userId, required bool forceRefresh}) async {
    var android = UniversalPlatform.isAndroid;
    if (android) {
      _photos = await LocalMongo.getUserPhotos(userId);
    } else {
      _photos.clear();
    }

    if (_photos.isEmpty || forceRefresh) {
      _photos = await DataAPI.getUserProjectPhotos(userId);
      if (android) await LocalMongo.addPhotos(photos: _photos);
    }
    _photoController.sink.add(_photos);
    pp('💜 💜 💜 MonitorBloc: getUserProjectPhotos found: 💜 ${_photos.length} photos ');
    return _photos;
  }

  Future<List<Video>> getUserProjectVideos(
      {required String userId, required bool forceRefresh}) async {
    var android = UniversalPlatform.isAndroid;
    if (android) {
      _videos = await LocalMongo.getUserVideos(userId);
    } else {
      _videos.clear();
    }

    if (_videos.isEmpty || forceRefresh) {
      _videos = await DataAPI.getUserProjectVideos(userId);
      if (android) await LocalMongo.addVideos(videos: _videos);
    }
    _videoController.sink.add(_videos);
    pp('💜 💜 💜 MonitorBloc: getUserProjectVideos found: 💜 ${_videos.length} videos ');
    return _videos;
  }

  Future refreshUserData(
      {required String userId, required String organizationId, required bool forceRefresh}) async {
    pp('💜 💜 💜 MonitorBloc: refreshUserData ... forceRefresh: $forceRefresh');
    try {
      getOrganizationProjects(
          organizationId: organizationId, forceRefresh: forceRefresh);
      getOrganizationUsers(
          organizationId: organizationId, forceRefresh: forceRefresh);
      getUserProjectPhotos(userId: userId, forceRefresh: forceRefresh);
      getUserProjectVideos(userId: userId, forceRefresh: forceRefresh);
      getMonitorFieldMonitorSchedules(
          userId: userId, forceRefresh: forceRefresh);
    } catch (e) {
      pp('We seem fucked! ');
      throw e;
    }
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
    _fieldMonitorScheduleController.close();
    _projectVideoController.close();
    _projectPhotoController.close();
  }
}
