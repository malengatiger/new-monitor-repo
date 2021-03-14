import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/position.dart';

class Photo {
  String url, thumbnailUrl, caption, created, photoId;
  String userId, organizationId;
  String userName;
  Position projectPosition;
  double distanceFromProjectPosition;
  String projectId, projectName;
  int height, width;

  Photo(
      {@required this.url,
      @required this.caption,
      @required this.created,
      @required this.userId,
      @required this.userName,
      @required this.projectPosition,
      @required this.distanceFromProjectPosition,
      @required this.projectId,
      @required this.thumbnailUrl,
      @required this.photoId,
      @required this.organizationId,
      @required this.projectName,
      @required this.height,
      @required this.width});

  Photo.fromJson(Map data) {
    this.url = data['url'];
    this.thumbnailUrl = data['thumbnailUrl'];
    this.caption = data['caption'];
    this.height = data['height'];
    this.width = data['width'];
    this.created = data['created'];
    this.organizationId = data['organizationId'];
    this.userId = data['userId'];
    this.photoId = data['photoId'];
    this.userName = data['userName'];
    this.distanceFromProjectPosition = data['distanceFromProjectPosition'];
    this.projectId = data['projectId'];
    this.projectName = data['projectName'];
    if (data['projectPosition'] != null) {
      this.projectPosition = Position.fromJson(data['projectPosition']);
    }
    if (this.height == null) {
      this.height = -5;
    }
    if (this.width == null) {
      this.width = -10;
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'url': url,
      'caption': caption,
      'created': created,
      'width': width,
      'height': height,
      'userId': userId,
      'organizationId': organizationId,
      'photoId': photoId,
      'userName': userName,
      'distanceFromProjectPosition': distanceFromProjectPosition,
      'projectId': projectId,
      'projectName': projectName,
      'thumbnailUrl': thumbnailUrl,
      'projectPosition':
          projectPosition == null ? null : projectPosition.toJson()
    };
    return map;
  }
}

class Video {
  String url, caption, created, thumbnailUrl, videoId;
  String userId, userName, organizationId;
  Position projectPosition;
  double distanceFromProjectPosition;
  String projectId, projectName;

  Video(
      {@required
          this.url,
      this.caption,
      @required
          this.created,
      @required
          this.userId,
      @required
          this.userName,
      @required
          this.projectPosition,
      @required
          this.distanceFromProjectPosition,
      @required
          this.projectId,
      @required
          this.thumbnailUrl,
      @required
          this.videoId,
      @required
          this.organizationId,
      @required
          this.projectName}); // Video({@required this.url, this.userId, @required this.created});

  Video.fromJson(Map data) {
    this.url = data['url'];
    this.caption = data['caption'];
    this.created = data['created'];
    this.userId = data['userId'];
    this.organizationId = data['organizationId'];
    this.thumbnailUrl = data['thumbnailUrl'];
    this.videoId = data['videoId'];
    this.userName = data['userName'];
    this.distanceFromProjectPosition = data['distanceFromProjectPosition'];
    this.projectId = data['projectId'];
    this.projectName = data['projectName'];
    if (data['projectPosition'] != null) {
      this.projectPosition = Position.fromJson(data['projectPosition']);
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'url': url,
      'caption': caption,
      'created': created,
      'userId': userId,
      'videoId': videoId,
      'organizationId': organizationId,
      'userName': userName,
      'thumbnailUrl': thumbnailUrl,
      'distanceFromProjectPosition': distanceFromProjectPosition,
      'projectId': projectId,
      'projectName': projectName,
      'projectPosition':
          projectPosition == null ? null : projectPosition.toJson()
    };
    return map;
  }
}

class Condition {
  String url, caption, created;
  String userId, userName;
  Position projectPosition;
  int rating;
  String projectId, projectName;

  Condition(
      {@required
          this.url,
      this.caption,
      @required
          this.created,
      @required
          this.userId,
      @required
          this.userName,
      @required
          this.projectPosition,
      @required
          this.rating,
      @required
          this.projectId,
      @required
          this.projectName}); // Video({@required this.url, this.userId, @required this.created});

  Condition.fromJson(Map data) {
    this.url = data['url'];
    this.caption = data['caption'];
    this.created = data['created'];
    this.userId = data['userId'];

    this.userName = data['userName'];
    this.rating = data['rating'];
    this.projectId = data['projectId'];
    this.projectName = data['projectName'];
    if (data['projectPosition'] != null) {
      this.projectPosition = Position.fromJson(data['projectPosition']);
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'url': url,
      'caption': caption,
      'created': created,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'projectId': projectId,
      'projectName': projectName,
      'projectPosition':
          projectPosition == null ? null : projectPosition.toJson()
    };
    return map;
  }
}

/*
data class Condition(var _partitionKey: String?, @Id var _id: String?,
                 var projectId: String,
                 var projectName: String,
                 var rating: Int,
                 var caption: String?,
                 var userId: String,
                 var userName: String,
                 var created: String) {}
 */
