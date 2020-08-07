import 'package:flutter/cupertino.dart';
import 'package:monitorlibrary/data/interfaces.dart';
import 'package:monitorlibrary/data/photo.dart' as ph;
import 'package:monitorlibrary/data/user.dart';

/*
data class MonitorReport(var monitorReportId: String?, var projectId: String,
                         var user: User, var rating: Rating, var photos: List<Photo>,
                         var videos: List<Video>, var description: String, var created: String) {}
 */
class MonitorReport {
  String projectId, created;
  Rating rating;
  String description;
  List<ph.Photo> photos;
  List<ph.Video> videos;
  User user;
  MonitorReport(
      {@required this.projectId,
      this.description,
      @required this.created,
      this.user,
      this.photos,
      this.videos,
      this.rating});

  MonitorReport.fromJson(Map data) {
    this.projectId = data['projectId'];
    this.rating = data['rating'];
    this.created = data['created'];
    this.description = data['description'];
    this.photos = [];
    if (data['user'] != null) {
      this.user = User.fromJson(data['user']);
    }
    if (data['photos'] != null) {
      if (data['photos'] is List) {
        List mList = data['photos'];
        mList.forEach((photo) {
          this.photos.add(ph.Photo.fromJson(photo));
        });
      }
    }
    if (data['videos'] != null) {
      if (data['videos'] is List) {
        List mList = data['videos'];
        mList.forEach((video) {
          this.videos.add(ph.Video.fromJson(video));
        });
      }
    }
    this.rating = data['rating'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'projectId': projectId,
      'rating': rating,
      'created': created,
      'description': description,
    };
    return map;
  }
}
