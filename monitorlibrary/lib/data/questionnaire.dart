import 'package:meta/meta.dart';
import 'package:monitorlibrary/data/question.dart';
import 'package:monitorlibrary/data/section.dart';

import 'content.dart';

class Questionnaire {
  String questionnaireId, title, name, organizationId, description, organizationName, countryId, created, countryName;
  List<Section> sections;


  Questionnaire({this.title, this.name,
      this.organizationId, this.description, this.organizationName,
      this.countryId, this.created, this.countryName, this.sections});

  Questionnaire.fromJson(Map data) {
    this.title = data['title'];
    this.organizationId = data['organizationId'];
    this.sections = List();
    if ( data['sections'] != null) {
      List list =  data['sections'];
      list.forEach((m) {
        this.sections.add(Section.fromJson(m));
      });
    }
    this.description = data['description'];
    this.organizationName = data['organizationName'];
    this.countryId = data['countryId'];
    this.created = data['created'];
    this.countryName = data['countryName'];

  }
  Map<String, dynamic> toJson() {
    List mSecs = List();
    if (sections != null) {
      sections.forEach((s) {
        mSecs.add(s.toJson());
      });
    }

    Map<String, dynamic> map = {
      'title': title,
      'organizationId': organizationId,
      'description': description,
      'sections': mSecs,
      'organizationName': organizationName,
      'created': created,
      'countryName': countryName,
      'countryId': countryId,


    };
    return map;
  }
}
