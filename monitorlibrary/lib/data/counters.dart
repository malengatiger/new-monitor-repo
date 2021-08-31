import 'package:meta/meta.dart';

class UserCount {
  String? userId;
  int photos = 0, videos = 0, projects = 0;

  UserCount(
      {required this.userId,
      required this.projects,
      required this.videos,
      required this.photos});

  UserCount.fromJson(Map data) {
    this.userId = data['userId'];
    this.videos = data['videos'];
    this.projects = data['projects'];
    this.photos = data['photos'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'userId': userId,
      'videos': videos,
      'projects': projects,
      'photos': photos,
    };
    return map;
  }
}

class ProjectCount {
  String? projectId;
  int photos = 0, videos = 0;

  ProjectCount(
      {required this.projectId, required this.videos, required this.photos});

  ProjectCount.fromJson(Map data) {
    this.projectId = data['projectId'];
    this.videos = data['videos'];
    this.photos = data['photos'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'projectId': projectId,
      'videos': videos,
      'photos': photos,
    };
    return map;
  }
}
