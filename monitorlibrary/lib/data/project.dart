import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/monitor_report.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/ratingContent.dart';

import 'city.dart';
import 'community.dart';
import 'photo.dart' as ph;

/*
var projectPoints: List<Position>?
 */
class Project {
  String name, projectId, description, organizationId, created;
  String organizationName;
  List<City> nearestCities;
  Position position;
  List<Position> projectPoints;
  List<ph.Photo> photos;
  List<ph.Video> videos;
  List<RatingContent> ratings;
  List<Community> communities;
  List<MonitorReport> monitorReports;
  double monitorMaxDistanceInMetres;
  Project(
      {@required this.name,
      @required this.description,
      this.organizationId,
      this.communities,
      this.nearestCities,
      this.photos,
      this.videos,
      this.ratings,
      this.created,
      this.projectPoints,
      this.position,
      this.monitorReports,
      this.organizationName,
      this.monitorMaxDistanceInMetres,
      @required this.projectId});

  Project.fromJson(Map data) {
    this.name = data['name'];
    this.projectId = data['projectId'];
    this.description = data['description'];
    this.organizationId = data['organizationId'];
    this.projectId = data['projectId'];
    this.created = data['created'];
    this.organizationName = data['organizationName'];
    this.monitorMaxDistanceInMetres = data['monitorMaxDistanceInMetres'];

    if (data['position'] != null) {
      position = Position.fromJson(data['position']);
    }
    this.monitorReports = [];
    if (data['monitorReports'] != null) {
      List list = data['monitorReports'];
      list.forEach((m) {
        this.monitorReports.add(MonitorReport.fromJson(m));
      });
    }
    this.communities = [];
    if (data['communities'] != null) {
      List list = data['communities'];
      list.forEach((m) {
        this.communities.add(Community.fromJson(m));
      });
    }

    this.nearestCities = [];
    if (data['nearestCities'] != null) {
      List list = data['nearestCities'];
      list.forEach((m) {
        this.nearestCities.add(City.fromJson(m));
      });
    }
    this.projectPoints = [];
    if (data['projectPoints'] != null) {
      List list = data['projectPoints'];
      list.forEach((m) {
        this.projectPoints.add(Position.fromJson(m));
      });
    }
    this.photos = [];
    if (data['photos'] != null) {
      List list = data['photos'];
      list.forEach((m) {
        this.photos.add(ph.Photo.fromJson(m));
      });
    }
    this.videos = [];
    if (data['videos'] != null) {
      List list = data['videos'];
      list.forEach((m) {
        this.videos.add(ph.Video.fromJson(m));
      });
    }
    this.ratings = [];
    if (data['ratings'] != null) {
      List list = data['ratings'];
      list.forEach((m) {
        this.ratings.add(RatingContent.fromJson(m));
      });
    }
  }
  Map<String, dynamic> toJson() {
    List mprojectPoints = List();
    if (projectPoints != null) {
      projectPoints.forEach((pos) {
        mprojectPoints.add(pos.toJson());
      });
    }
    List mPhotos = List();
    if (photos != null) {
      photos.forEach((photo) {
        mPhotos.add(photo.toJson());
      });
    }
    List mVideos = List();
    if (videos != null) {
      videos.forEach((photo) {
        mVideos.add(photo.toJson());
      });
    }
    List mRatings = List();
    if (ratings != null) {
      ratings.forEach((r) {
        mRatings.add(r.toJson());
      });
    }
    List mSett = List();
    if (communities != null) {
      communities.forEach((r) {
        mSett.add(r.toJson());
      });
    }
    List mCities = List();
    if (nearestCities != null) {
      nearestCities.forEach((r) {
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
      'projectPoints': mprojectPoints,
    };
    return map;
  }
}
