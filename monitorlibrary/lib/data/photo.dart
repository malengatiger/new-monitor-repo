import 'package:flutter/material.dart';

class Photo {
  String url, caption, created;
  String userId;

  Photo({@required this.url, this.userId, @required this.created});

  Photo.fromJson(Map data) {
    this.url = data['url'];
    this.caption = data['caption'];
    this.created = data['created'];
    this.userId = data['userId'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'url': url,
      'caption': caption,
      'created': created,
      'userId': userId,
    };
    return map;
  }
}

class Video {
  String url, caption, created;
  String userId;
  Video({@required this.url, this.userId, @required this.created});

  Video.fromJson(Map data) {
    this.url = data['url'];
    this.caption = data['caption'];
    this.created = data['created'];
    this.userId = data['userId'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'url': url,
      'caption': caption,
      'created': created,
      'userId': userId,
    };
    return map;
  }
}
