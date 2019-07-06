import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/interfaces.dart';

import 'answer.dart';

class Question {
  String text, created;
  List<Answer> answers;
  QuestionType questionType;
  List<String> choices;

  Question(
      {@required this.text,
      this.answers,
      @required this.questionType,
      this.choices});

  Question.fromJson(Map data) {
    this.text = data['text'];
    this.created = data['created'];
    this.choices = data['choices'];
    this.questionType = data['questionType'];
    this.answers = data['answers'];

  }
  Map<String, dynamic> toJson() {
    List mAnswers = [];
    if (answers != null) {
      answers.forEach((a) {
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
