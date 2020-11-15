import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/position.dart';

class Photo {
  String url, thumbnailUrl, caption, created;
  String userId;
  String userName;
  Position projectPosition;
  double distanceFromProjectPosition;
  String projectId, projectName;

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
      @required this.projectName});

  Photo.fromJson(Map data) {
    this.url = data['url'];
    this.thumbnailUrl = data['thumbnailUrl'];
    this.caption = data['caption'];
    this.created = data['created'];
    this.userId = data['userId'];
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
  String url, caption, created;
  String userId, userName;
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
          this.projectName}); // Video({@required this.url, this.userId, @required this.created});

  Video.fromJson(Map data) {
    this.url = data['url'];
    this.caption = data['caption'];
    this.created = data['created'];
    this.userId = data['userId'];

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
      'userName': userName,
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
