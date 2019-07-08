import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/question.dart';

import 'content.dart';

class Section {
  String title, description;
  List<Question> questions;
  String sectionNumber;

  Section(
      {this.title,
        this.sectionNumber,
        this.questions,
        this.description});

  Section.fromJson(Map data) {
    this.title = data['title'];
    this.sectionNumber = data['sectionNumber'];
    this.questions = List();
    if (data['questions'] != null) {
      List  list = data['questions'];
      list.forEach((m) {
        this.questions.add(Question.fromJson(m));
      });
    }
    this.description = data['description'];

  }
  Map<String, dynamic> toJson() {
    List mQuestions = List();
    if (questions != null) {
      questions.forEach((photo) {
        mQuestions.add(photo.toJson());
      });
    }

    Map<String, dynamic> map = {
      'title': title,
      'sectionNumber': sectionNumber,
      'description': description,
      'questions': mQuestions,


    };
    return map;
  }
}
