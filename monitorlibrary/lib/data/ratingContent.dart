import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/interfaces.dart';
import 'package:monitorlibrary/data/position.dart';

class RatingContent {
  String? userId, created;
  String? comment;
  Position? position;
  Rating? rating;

  RatingContent(
      {
      required this.userId,
      this.comment,
      required this.position,
      required this.rating});

  RatingContent.fromJson(Map data) {
    this.userId = data['userId'];
    this.comment = data['comment'];
    this.created = data['created'];
    this.position = data['position'];
    this.rating = data['rating'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'userId': userId,
      'comment': comment,
      'created': created,
      'position': position,
      'rating': rating,
    };
    return map;
  }
}
