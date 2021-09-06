import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/question.dart';

import 'content.dart';

class Section {
  String? title, description, sectionId;
  List<Question>? questions;
  String? sectionNumber;

  Section(
      {required this.title,
        required this.sectionNumber,
        required this.questions, required this.sectionId,
        required this.description});

  Section.fromJson(Map data) {
    this.sectionId = data['sectionId'];
    this.title = data['title'];
    this.sectionNumber = data['sectionNumber'];
    this.questions = [];
    if (data['questions'] != null) {
      List  list = data['questions'];
      list.forEach((m) {
        this.questions!.add(Question.fromJson(m));
      });
    }
    this.description = data['description'];

  }
  Map<String, dynamic> toJson() {
    List mQuestions = [];
    if (questions != null) {
      questions!.forEach((photo) {
        mQuestions.add(photo.toJson());
      });
    }

    Map<String, dynamic> map = {
      'title': title,
      'sectionNumber': sectionNumber,
      'description': description,
      'questions': mQuestions,
      'sectionId': sectionId,


    };
    return map;
  }
}
