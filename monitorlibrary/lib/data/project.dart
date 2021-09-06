import 'package:monitorlibrary/data/monitor_report.dart';
import 'package:monitorlibrary/data/project_position.dart';
import 'package:monitorlibrary/data/ratingContent.dart';

import '../functions.dart';
import 'city.dart';
import 'community.dart';
import 'photo.dart' as ph;

class Project {
  String? _id, name, projectId, description, organizationId, created;
  String? organizationName;
  List<City>? nearestCities;

  List<ProjectPosition>? projectPositions;
  List<ph.Photo>? photos;
  List<ph.Video>? videos;
  List<RatingContent>? ratings;
  List<Community>? communities;
  List<MonitorReport>? monitorReports;
  double? monitorMaxDistanceInMetres;
  Project(
      {required this.name,
      required this.description,
      this.organizationId,
      required this.communities,
      required this.nearestCities,
      required this.photos,
      required this.videos,
      required this.ratings,
      required this.created,
      required this.projectPositions,
      required this.monitorReports,
      required this.organizationName,
      required this.monitorMaxDistanceInMetres,
      required this.projectId});

  Project.fromJson(Map data) {
    this.name = data['name'];

    this.projectId = data['projectId'];
    this.description = data['description'];
    this.organizationId = data['organizationId'];
    this.created = data['created'];
    this.organizationName = data['organizationName'];
    pp('Project.fromJson 😑 😑 😑 log 1 ...');
    this.monitorMaxDistanceInMetres = data['monitorMaxDistanceInMetres'];

    pp('Project.fromJson 😑 😑 😑 log 2 ...');
    this.monitorReports = [];
    if (data['monitorReports'] != null) {
      List list = data['monitorReports'];
      list.forEach((m) {
        this.monitorReports!.add(MonitorReport.fromJson(m));
      });
    }
    this.communities = [];
    if (data['communities'] != null) {
      List list = data['communities'];
      list.forEach((m) {
        this.communities!.add(Community.fromJson(m));
      });
    }
    pp('Project.fromJson 😑 😑 😑 log 3 ...');
    this.nearestCities = [];
    if (data['nearestCities'] != null) {
      List list = data['nearestCities'];
      list.forEach((m) {
        this.nearestCities!.add(City.fromJson(m));
      });
    }
    pp('Project.fromJson 😑 😑 😑 log 4 ...');
    this.projectPositions = [];
    if (data['projectPositions'] != null) {
      List list = data['projectPositions'];
      list.forEach((m) {
        this.projectPositions!.add(ProjectPosition.fromJson(m));
      });
    }
    pp('Project.fromJson 😑 😑 😑 log 5 ...');
    this.photos = [];
    if (data['photos'] != null) {
      List list = data['photos'];
      list.forEach((m) {
        this.photos!.add(ph.Photo.fromJson(m));
      });
    }
    pp('Project.fromJson 😑 😑 😑 log 6 ...');
    this.videos = [];
    if (data['videos'] != null) {
      List list = data['videos'];
      list.forEach((m) {
        this.videos!.add(ph.Video.fromJson(m));
      });
    }
    pp('Project.fromJson 😑 😑 😑 log 7 ...');
    this.ratings = [];
    if (data['ratings'] != null) {
      List list = data['ratings'];
      list.forEach((m) {
        this.ratings!.add(RatingContent.fromJson(m));
      });
    }
    pp('Project.fromJson 😑 😑 😑 logs end ...');
  }
  Map<String, dynamic> toJson() {
    List mProjectPositions = [];
    if (projectPositions != null) {
      projectPositions!.forEach((pos) {
        mProjectPositions.add(pos.toJson());
      });
    }
    List mPhotos = [];
    if (photos != null) {
      photos!.forEach((photo) {
        mPhotos.add(photo.toJson());
      });
    }
    List mVideos = [];
    if (videos != null) {
      videos!.forEach((photo) {
        mVideos.add(photo.toJson());
      });
    }
    List mRatings = [];
    if (ratings != null) {
      ratings!.forEach((r) {
        mRatings.add(r.toJson());
      });
    }
    List mSett = [];
    if (communities != null) {
      communities!.forEach((r) {
        mSett.add(r.toJson());
      });
    }
    List mCities = [];
    if (nearestCities != null) {
      nearestCities!.forEach((r) {
        mCities.add(r.toJson());
      });
    }
    Map<String, dynamic> map = {
      'name': name,
      'projectId': projectId,
      'description': description,
      'organizationId': organizationId,
      'monitorMaxDistanceInMetres': monitorMaxDistanceInMetres,
      'communities': mSett,
      'organizationName': organizationName,
      'nearestCities': mCities,
      'photos': mPhotos,
      'videos': mVideos,
      'ratings': mRatings,
      'created': created,
      'projectPositions': mProjectPositions,
    };
    return map;
  }
}
