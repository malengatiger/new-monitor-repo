import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/local_db_api.dart';
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

  Stream get projectPhotoStream => _projectPhotoController.stream;

  Stream get projectVideoStream => _projectVideoController.stream;

  Stream get reportStream => _reportController.stream;

  Stream get settlementStream => _communityController.stream;

  Stream get questionnaireStream => _questController.stream;

  Stream get projectStream => _projController.stream;

  Stream get projectPositionsStream => _projPositionsController.stream;

  Stream get countryStream => _countryController.stream;

  Stream get activeUserStream => _activeUserController.stream;

  Stream get usersStream => _userController.stream;

  Stream get activeQuestionnaireStream => _activeQuestionnaireController.stream;

  Stream get fieldMonitorScheduleStream =>
      _fieldMonitorScheduleController.stream;

  Stream get photoStream => _photoController.stream;

  Stream get videoStream => _videoController.stream;

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
      if (project.organizationId == _user.organizationId) {
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
      {String organizationId, bool forceRefresh}) async {
    if (_user == null) {
      _user = await Prefs.getUser();
    }
    pp('💜 💜 💜 💜 MonitorBloc: getOrganizationProjects: for organizationId: $organizationId ; '
        'user: 💜 ${user.name} user.organizationId: ${user.organizationId} user.organizationName: ${user.organizationName} ');

    _projects = await LocalDBAPI.getProjects();

    if (_projects.isEmpty || forceRefresh) {
      _projects = await DataAPI.findProjectsByOrganization(organizationId);
      await LocalDBAPI.addProjects(projects: _projects);
    }
    _projController.sink.add(_projects);
    pp('💜 💜 💜 💜 MonitorBloc: OrganizationProjects found: 💜 ${_projects.length} projects 💜');
    _projects.forEach((project) {
      pp('💜 💜 💜 💜 Org PROJECT: ${project.name} 🍏 ${project.organizationName}  🍏 ${project.organizationId}');
    });

    return _projects;
  }

  Future refreshOrgDashboardData({bool forceRefresh = false}) async {
    if (_user == null) {
      _user = await Prefs.getUser();
    }
    pp('💜 💜 💜 💜 💜 💜 MonitorBloc:refreshDashboardData .... 💜 💜 💜 💜 💜 💜');
    await getOrganizationUsers(
        organizationId: _user.organizationId, forceRefresh: forceRefresh);
    await getOrganizationProjects(
        organizationId: _user.organizationId, forceRefresh: forceRefresh);
    await getOrganizationPhotos(
        organizationId: _user.organizationId, forceRefresh: forceRefresh);
    await getOrganizationVideos(
        organizationId: _user.organizationId, forceRefresh: forceRefresh);
    await getOrgFieldMonitorSchedules(
        organizationId: _user.organizationId, forceRefresh: forceRefresh);
  }

  Future<List<User>> getOrganizationUsers(
      {String organizationId, bool forceRefresh = false}) async {
    _users = await LocalDBAPI.getUsers();

    if (_users.isEmpty || forceRefresh) {
      _users = await DataAPI.findUsersByOrganization(organizationId);
      await LocalDBAPI.addUsers(users: _users);
    }
    _userController.sink.add(_users);
    pp('💜 💜 💜 MonitorBloc: getOrganizationUsers found: 💜 ${_users.length} users ');
    _users.forEach((element) {
      pp('😲 😡  USER:  🍏 ${element.name} 🍏 ${element.organizationName}');
    });

    return _users;
  }

  Future<List<ProjectPosition>> getProjectPositions(
      {String projectId, bool forceRefresh}) async {
    _projectPositions = await LocalDBAPI.getProjectPositions(projectId);

    if (_projectPositions.isEmpty || forceRefresh) {
      _projectPositions = await DataAPI.findProjectPositionsById(projectId);

      await LocalDBAPI.addProjectPositions(positions: _projectPositions);
    }
    _projPositionsController.sink.add(_projectPositions);
    pp('💜 💜 💜 MonitorBloc: getProjectPositions found: 💜 ${_projectPositions.length} projectPositions ');
    return _projectPositions;
  }

  Future<List<Photo>> getProjectPhotos(
      {String projectId, bool forceRefresh = false}) async {
    List<Photo> photos = [];

    photos = await LocalDBAPI.getProjectPhotos(projectId);

    if (photos.isEmpty || forceRefresh) {
      photos = await DataAPI.findPhotosByProject(projectId);
      await LocalDBAPI.addPhotos(photos: photos);
    }
    _projectPhotoController.sink.add(photos);
    pp('💜 💜 💜 MonitorBloc: getProjectPhotos found: 💜 ${photos.length} photos ');

    return photos;
  }

  Future<List<FieldMonitorSchedule>> getProjectFieldMonitorSchedules(
      {String projectId, bool forceRefresh = false}) async {
    _schedules = await LocalDBAPI.getProjectMonitorSchedules(projectId);

    if (_schedules.isEmpty || forceRefresh) {
      _schedules = await DataAPI.getProjectFieldMonitorSchedules(projectId);
      await LocalDBAPI.addFieldMonitorSchedules(schedules: _schedules);
    }
    var m = filterSchedulesByProject(_schedules);
    _schedules = m;
    _fieldMonitorScheduleController.sink.add(_schedules);
    pp('🔵 🔵 🔵  MonitorBloc: getProjectFieldMonitorSchedules found: 💜 ${_schedules.length} schedules ');

    return _schedules;
  }

  Future<List<FieldMonitorSchedule>> getMonitorFieldMonitorSchedules(
      {String userId, bool forceRefresh = false}) async {
    _schedules = await LocalDBAPI.getFieldMonitorSchedules(userId);

    if (_schedules.isEmpty || forceRefresh) {
      _schedules = await DataAPI.getMonitorFieldMonitorSchedules(userId);
      await LocalDBAPI.addFieldMonitorSchedules(schedules: _schedules);
    }
    _schedules.sort((a, b) => b.date.compareTo(a.date));
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
    mList.sort((a, b) => b.date.compareTo(a.date));
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
      {String organizationId, bool forceRefresh = false}) async {
    _schedules =
        await LocalDBAPI.getOrganizationMonitorSchedules(organizationId);

    if (_schedules.isEmpty || forceRefresh) {
      _schedules = await DataAPI.getOrgFieldMonitorSchedules(organizationId);
      await LocalDBAPI.addFieldMonitorSchedules(schedules: _schedules);
    }
    var m = filterSchedulesByProject(_schedules);
    _schedules = m;
    _fieldMonitorScheduleController.sink.add(_schedules);
    pp('🔵 🔵 🔵 MonitorBloc: getOrgFieldMonitorSchedules found: 🔵 ${_schedules.length} schedules ');

    return _schedules;
  }

  Future<List<Photo>> getOrganizationPhotos(
      {String organizationId, bool forceRefresh = false}) async {
    try {
      var android = UniversalPlatform.isAndroid;
      if (android) {
        _photos = await LocalDBAPI.getPhotos();
      } else {
        _photos.clear();
      }

      if (_photos.isEmpty || forceRefresh) {
        _photos = await DataAPI.getOrganizationPhotos(organizationId);
        if (android) await LocalDBAPI.addPhotos(photos: _photos);
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
      {String organizationId, bool forceRefresh = false}) async {
    try {
      var android = UniversalPlatform.isAndroid;
      if (android) {
        _videos = await LocalDBAPI.getVideos();
      } else {
        _videos.clear();
      }
      if (_videos.isEmpty || forceRefresh) {
        _videos = await DataAPI.getOrganizationVideos(organizationId);
        if (android) await LocalDBAPI.addVideos(videos: _videos);
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
      {String projectId, bool forceRefresh = false}) async {
    List<Video> videos = [];
    var android = UniversalPlatform.isAndroid;
    if (android) {
      videos = await LocalDBAPI.getProjectVideos(projectId);
    }
    if (videos.isEmpty || forceRefresh) {
      videos = await DataAPI.findVideosById(projectId);
      if (android) await LocalDBAPI.addVideos(videos: videos);
    }
    _projectVideoController.sink.add(videos);
    pp('💜 💜 💜 MonitorBloc: getProjectVideos found: 💜 ${videos.length} videos ');

    return videos;
  }

  Future refreshProjectData({String projectId, bool forceRefresh}) async {
    await getProjectPhotos(projectId: projectId, forceRefresh: forceRefresh);
    await getProjectVideos(projectId: projectId, forceRefresh: forceRefresh);
    await getProjectFieldMonitorSchedules(
        projectId: projectId, forceRefresh: forceRefresh);
    return null;
  }

  Future<List<Photo>> getUserProjectPhotos(
      {String userId, bool forceRefresh}) async {
    var android = UniversalPlatform.isAndroid;
    if (android) {
      _photos = await LocalDBAPI.getUserPhotos(userId);
    } else {
      _photos.clear();
    }

    if (_photos.isEmpty || forceRefresh) {
      _photos = await DataAPI.getUserProjectPhotos(userId);
      if (android) await LocalDBAPI.addPhotos(photos: _photos);
    }
    _photoController.sink.add(_photos);
    pp('💜 💜 💜 MonitorBloc: getUserProjectPhotos found: 💜 ${_photos.length} photos ');
    return _photos;
  }

  Future<List<Video>> getUserProjectVideos(
      {String userId, bool forceRefresh}) async {
    var android = UniversalPlatform.isAndroid;
    if (android) {
      _videos = await LocalDBAPI.getUserVideos(userId);
    } else {
      _videos.clear();
    }

    if (_videos.isEmpty || forceRefresh) {
      _videos = await DataAPI.getUserProjectVideos(userId);
      if (android) await LocalDBAPI.addVideos(videos: _videos);
    }
    _videoController.sink.add(_videos);
    pp('💜 💜 💜 MonitorBloc: getUserProjectVideos found: 💜 ${_videos.length} videos ');
    return _videos;
  }

  Future refreshUserData(
      {String userId, String organizationId, bool forceRefresh}) async {
    pp('💜 💜 💜 MonitorBloc: refreshUserData ... forceRefresh: $forceRefresh');
    try {
      await getOrganizationProjects(
          organizationId: organizationId, forceRefresh: forceRefresh);
      await getOrganizationUsers(
          organizationId: organizationId, forceRefresh: forceRefresh);
      await getUserProjectPhotos(userId: userId, forceRefresh: forceRefresh);
      await getUserProjectVideos(userId: userId, forceRefresh: forceRefresh);
      await getMonitorFieldMonitorSchedules(
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
