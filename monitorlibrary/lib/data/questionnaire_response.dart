import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/question.dart';
import 'package:monitorlibrary/data/section.dart';

import 'content.dart';

class QuestionnaireResponse {
  String? questionnaireId, userId, respondentId, questionnaireResponseId;
  List<Section>? sections;

  QuestionnaireResponse({required this.questionnaireId, required this.userId,
    required this.respondentId,
    required this.questionnaireResponseId, required this.sections});

  QuestionnaireResponse.fromJson(Map data) {
    this.userId = data['userId'];
    this.questionnaireResponseId = data['questionnaireResponseId'];
    this.sections = data['sections'];
    this.respondentId = data['respondentId'];
    this.questionnaireId = data['questionnaireId'];
  }
  Map<String, dynamic> toJson() {
    List mSecs = [];
    if (sections != null) {
      sections!.forEach((s) {
        mSecs.add(s.toJson());
      });
    }

    Map<String, dynamic> map = {
      'userId': userId,
      'questionnaireResponseId': questionnaireResponseId,
      'sections': mSecs,
      'respondentId': respondentId,
      'questionnaireId': questionnaireId,
    };
    return map;
  }
}
