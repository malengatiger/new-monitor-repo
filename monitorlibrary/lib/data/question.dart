import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/interfaces.dart';

import 'answer.dart';

class Question {
  String? text, created;
  List<Answer>? answers;
  String? questionType;
  List<String>? choices;

  Question(
      {required this.text,
      this.answers,
      required this.questionType,
      this.choices});

  Question.fromJson(Map data) {
    this.text = data['text'];
    this.created = data['created'];
    this.choices = [];
    if (data['choices'] != null) {
      List  list = data['choices'];
      list.forEach((m) {
        this.choices!.add(m);
      });
    }
      this.questionType = data['questionType'];


    this.answers = [];
    if (data['answers'] != null) {
      List  list = data['answers'];
      list.forEach((m) {
        this.answers!.add(Answer.fromJson(m));
      });
    }

  }
  Map<String, dynamic> toJson() {
    List mAnswers = [];
    if (answers != null) {
      answers!.forEach((a) {
        mAnswers.add(a.toJson());
      });
    }
    Map<String, dynamic> map = {
      'text': text,
      'answers': mAnswers,
      'questionType': questionType,
      'choices': choices,
      'created': created,
    };
    return map;
  }
}
