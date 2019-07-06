import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/content.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/ratingContent.dart';
import 'package:monitorlibrary/data/settlement.dart';

import 'city.dart';

class Project {
  String name, countryId, projectId, description, organizationId, created;
  String organizationName;
  List<City> nearestCities;
  List<Position> positions;
  List<Content> photoUrls, videoUrls;
  List<RatingContent> ratings;
  List<Settlement> settlements;
  Project(
      {@required this.name,
      @required this.countryId,
      @required this.description,
      this.organizationId,
      this.settlements,
      this.nearestCities,
      this.photoUrls,
      this.videoUrls,
      this.ratings,
      this.created, this.positions,
      this.organizationName,
      @required this.projectId});

  Project.fromJson(Map data) {
    this.name = data['name'];
    this.countryId = data['countryId'];
    this.projectId = data['projectId'];
    this.description = data['description'];
    this.organizationId = data['organizationId'];
    this.projectId = data['projectId'];
    this.created = data['created'];
    this.organizationName = data['organizationName'];
    this.settlements = data['settlements'];
    this.nearestCities = data['nearestCities'];
    this.photoUrls = data['photoUrls'];
    this.videoUrls = data['videoUrls'];
    this.ratings = data['ratings'];
    this.positions = data['positions'];
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
      'countryId': countryId,
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
