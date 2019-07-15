import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/content.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/ratingContent.dart';
import 'package:monitorlibrary/data/settlement.dart';

import 'city.dart';

class Project {
  String name, projectId, description, organizationId, created;
  String organizationName;
  List<City> nearestCities;
  Position position;
  List<Position> positions;
  List<Content> photoUrls, videoUrls;
  List<RatingContent> ratings;
  List<Settlement> settlements;
  Project(
      {@required this.name,
      @required this.description,
      this.organizationId,
      this.settlements,
      this.nearestCities,
      this.photoUrls,
      this.videoUrls,
      this.ratings,
      this.created, this.positions, this.position,
      this.organizationName,
      @required this.projectId});

  Project.fromJson(Map data) {
    this.name = data['name'];
    this.projectId = data['projectId'];
    this.description = data['description'];
    this.organizationId = data['organizationId'];
    this.projectId = data['projectId'];
    this.created = data['created'];
    this.organizationName = data['organizationName'];

    if (data['position'] != null) {
      position = Position.fromJson(data['position']);
    }
    this.settlements = [];
    if (data['settlements'] != null) {
      List list = data['settlements'];
      list.forEach((m) {
        this.settlements.add(Settlement.fromJson(m));
      });
    }

    this.nearestCities = [];
    if (data['nearestCities'] != null) {
      List list = data['nearestCities'];
      list.forEach((m) {
        this.nearestCities.add(City.fromJson(m));
      });
    }
    this.positions = [];
    if (data['positions'] != null) {
      List list = data['positions'];
      list.forEach((m) {
        this.positions.add(Position.fromJson(m));
      });
    }
    this.photoUrls = [];
    if (data['photoUrls'] != null) {
      List list = data['photoUrls'];
      list.forEach((m) {
        this.photoUrls.add(Content.fromJson(m));
      });
    }
    this.videoUrls = [];
    if (data['videoUrls'] != null) {
      List list = data['videoUrls'];
      list.forEach((m) {
        this.videoUrls.add(Content.fromJson(m));
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
    List mPositions = List();
    if (positions != null) {
      positions.forEach((pos) {
        mPositions.add(pos.toJson());
      });
    }
    List mPhotos = List();
    if (photoUrls != null) {
      photoUrls.forEach((photo) {
        mPhotos.add(photo.toJson());
      });
    }
    List mVideos = List();
    if (videoUrls != null) {
      videoUrls.forEach((photo) {
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
    if (settlements != null) {
      settlements.forEach((r) {
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
      'projectId': projectId,
      'settlements': mSett,
      'organizationName': organizationName,
      'nearestCities': mCities,
      'photoUrls': mPhotos,
      'videoUrls': mVideos,
      'ratings': mRatings,
      'created': created,
      'positions': mPositions,
    };
    return map;
  }
}
