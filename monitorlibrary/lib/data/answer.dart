import 'package:meta/meta.dart';

import 'content.dart';

class Answer {
  String? text, aNumber, created;
  List<Content> photoUrls = [], videoUrls = [];

  Answer(
      {required this.text,
      required this.aNumber,
      required this.photoUrls,
      required this.videoUrls});

  Answer.fromJson(Map data) {
    this.text = data['text'];
    this.aNumber = data['aNumber'];
    this.photoUrls = data['photoUrls'];
    this.videoUrls = data['videoUrls'];
    this.created = data['created'];
  }
  Map<String, dynamic> toJson() {
    List mPhotos = [];

    photoUrls.forEach((photo) {
      mPhotos.add(photo.toJson());
    });

    List mVideos = [];

    videoUrls.forEach((photo) {
      mVideos.add(photo.toJson());
    });

    Map<String, dynamic> map = {
      'text': text,
      'aNumber': aNumber,
      'created': created,
      'photoUrls': mPhotos,
      'videoUrls': mVideos,
      'created': created,
    };
    return map;
  }
}
