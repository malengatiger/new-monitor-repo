import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/photo.dart';
import 'package:monitorlibrary/data/position.dart';
import 'package:monitorlibrary/data/ratingContent.dart';

import 'city.dart';

class Community {
  String name, countryId, communityId, email, countryName, created;
  int population;
  List<Position> polygon;
  List<Photo> photoUrls;
  List<Video> videoUrls;
  List<RatingContent> ratings;
  List<City> nearestCities;

  Community(
      {@required this.name,
      @required this.countryId,
      @required this.email,
      this.countryName,
      this.polygon,
      this.created,
      this.population,
      this.nearestCities,
      this.communityId});

  Community.fromJson(Map data) {
    this.name = data['name'];
    this.countryId = data['countryId'];
    this.communityId = data['communityId'];
    this.email = data['email'];
    this.countryName = data['countryName'];
    this.communityId = data['communityId'];
    this.created = data['created'];
    this.population = data['population'];
    this.polygon = List();
    if (data['polygon'] != null) {
      List list = data['polygon'];
      list.forEach((p) {
        this.polygon.add(Position.fromJson(p));
      });
    }
    this.photoUrls = List();
    if (data['photoUrls'] != null) {
      List list = data['photoUrls'];
      list.forEach((p) {
        this.photoUrls.add(Photo.fromJson(p));
      });
    }
    this.videoUrls = List();
    if (data['videoUrls'] != null) {
      List list = data['videoUrls'];
      list.forEach((p) {
        this.videoUrls.add(Video.fromJson(p));
      });
    }
    this.ratings = List();
    if (data['ratings'] != null) {
      List list = data['ratings'];
      list.forEach((p) {
        this.ratings.add(RatingContent.fromJson(p));
      });
    }
    this.nearestCities = List();
    if (data['nearestCities'] != null) {
      List list = data['nearestCities'];
      list.forEach((p) {
        this.nearestCities.add(City.fromJson(p));
      });
    }
  }
  Map<String, dynamic> toJson() {
    List mPolygon = List();
    if (polygon != null) {
      polygon.forEach((pos) {
        mPolygon.add(pos.toJson());
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
    List mCities = List();
    if (nearestCities != null) {
      nearestCities.forEach((r) {
        mCities.add(r.toJson());
      });
    }
    Map<String, dynamic> map = {
      'name': name,
      'countryId': countryId,
      'communityId': communityId,
      'email': email,
      'countryName': countryName,
      'communityId': communityId,
      'polygon': mPolygon,
      'population': population,
      'created': created,
      'photoUrls': mPhotos,
      'videoUrls': mVideos,
      'ratings': mRatings,
      'nearestCities': mCities,
    };
    return map;
  }
}
