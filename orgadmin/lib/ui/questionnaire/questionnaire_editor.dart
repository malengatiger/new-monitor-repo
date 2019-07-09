import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/section.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/slide_right.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:orgadmin/admin_bloc.dart';
import 'package:orgadmin/ui/questionnaire/section_editor.dart';

class QuestionnaireEditor extends StatefulWidget {
  final Questionnaire questionnaire;

  QuestionnaireEditor({this.questionnaire});

  @override
  _QuestionnaireEditorState createState() => _QuestionnaireEditorState();
}

class _QuestionnaireEditorState extends State<QuestionnaireEditor>
    implements SnackBarListener {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController sectionsController = TextEditingController();
  User user;
  Questionnaire questionnaire;
  bool showButton =  false;
  StreamSubscription<Questionnaire> subscription;

  void _close() {
    subscription.cancel();
  }
  @override
  void initState() {
    super.initState();
    if (widget.questionnaire != null) {
      titleController.text = widget.questionnaire.title;
      descController.text = widget.questionnaire.description;
      sectionsController.text = '${widget.questionnaire.sections.length}';
      title = widget.questionnaire.title;
      description = widget.questionnaire.description;
      numberOfSections = widget.questionnaire.sections.length;
      questionnaire = widget.questionnaire;
    }
    _getUser();
     _subscribe();
  }

  _subscribe() {
    subscription = adminBloc.activeQuestionnaireStream.listen((snapshot) {
      debugPrint('🛳 🛳 🛳 subscription listener fired, 🎽 active questionnaire arrived: ${snapshot}');
        setState(() {
          questionnaire = snapshot;
        });
    });
  }

  _getUser() async {
    user = await Prefs.getUser();
    questionnaire = await Prefs.getQuestionnaire();
    if  (questionnaire != null) {
      titleController.text = questionnaire.title;
      descController.text = questionnaire.description;
      sectionsController.text = '${questionnaire.sections.length}';
      title = questionnaire.title;
      description = questionnaire.description;
      numberOfSections = questionnaire.sections.length;
      setState(() {
        showButton = true;
      });
    } else {
      questionnaire = Questionnaire(
        title: 'New Questionnaire',
        description: 'Please edit',
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Questionnaire Editor'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(showButton? 120: 80),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                showButton == false?
                    Text(
                        'New Questionnaire',
                        style: Styles.blackBoldMedium,
                      )
                    : Text('${questionnaire.title}',
                        style: Styles.blackBoldMedium),
                SizedBox(
                  height: 20,
                ),
                showButton? RaisedButton(
                  onPressed: _writeQuestionnaireToDatabase,
                  elevation: 16,
                  color: Colors.pink[600],
                  child: Text('Submit New Questionnaire', style: Styles.whiteSmall,),
                ) : Container(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.brown[100],
      body: isBusy
          ? Center(
              child: Container(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 24,
                  backgroundColor: Colors.teal[700],
                ),
              ),
            )
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 24,
                          ),
                          Text('Questionnaire Details',
                              style: Styles.blackBoldMedium),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            onChanged: _onTitle,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              hintText: 'Enter Questionnaire Title',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            onChanged: _onDescription,
                            keyboardType: TextInputType.multiline,
                            controller: descController,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              hintText: 'Enter Questionnaire Description',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            onChanged: _onSections,
                            controller: sectionsController,
                            keyboardType:
                                TextInputType.numberWithOptions(signed: false),
                            decoration: InputDecoration(
                              labelText: 'Number of Sections',
                              hintText: 'Number of Questionnaire Sections',
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          RaisedButton(
                            onPressed: _processFirstQuestionnairePart,
                            elevation: 8,
                            color: Colors.indigo[400],
                            child: Padding(
                              padding: const EdgeInsets.only(left:28.0, right: 28),
                              child: Text(
                                'Edit Sections',
                                style: Styles.whiteSmall,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String title, description;
  int numberOfSections = 1;

  void _onTitle(String value) async {
    title = value;
    questionnaire.title = title;
    await Prefs.saveQuestionnaire(questionnaire);
    adminBloc.updateActiveQuestionnaire(questionnaire);
  }

  void _onDescription(String value) async{
    description = value;
    questionnaire.description = description;
    await Prefs.saveQuestionnaire(questionnaire);
    adminBloc.updateActiveQuestionnaire(questionnaire);
  }

  void _onSections(String value) {
    numberOfSections = int.parse(value);
  }

  bool isBusy = false;
  void _processFirstQuestionnairePart() async {
    setState(() {
      isBusy = true;
    });
    if (title == null || title.isEmpty) {
      _showErrorSnack('💦 💦 Enter Title');
    }
    if (description == null || description.isEmpty) {
      _showErrorSnack('💦 💦 Enter Description');
    }
    var country = await Prefs.getCountry();
    if (country == null) {
      country = Country(
        name : 'South Africa',
        countryCode: 'ZA',
      );
      country.countryId = '5d1f4e0d41ec6bc61c3c3189';
    }
    if (questionnaire ==  null) {
      questionnaire  = Questionnaire();
    }
    questionnaire.title = title;
    questionnaire.description = description;
    questionnaire.organizationName  = user.organizationName;
    questionnaire.organizationId = user.organizationId;
    questionnaire.countryId = country.countryId;
    questionnaire.countryName = country.name;

    //add  number of sections
    if (numberOfSections == 0) {
      numberOfSections = 1;
    }
    if (questionnaire.sections == null || questionnaire.sections.isEmpty) {
      for (var i = 0; i < numberOfSections; i++) {
        var sec = Section(
          sectionNumber: '${i + 1}',
          title: 'Section ${i + 1} Title',
        );
        questionnaire.sections = [];
        questionnaire.sections.add(sec);
      }
    } else {
      print('⛱⛱ sections exist, ⛱ templates may not be necessary');
      if (numberOfSections - questionnaire.sections.length > 0) {
        var number = numberOfSections - questionnaire.sections.length;
        print('⛱⛱ sections exist, ⛱ but extra $number templates are necessary');
        for (var i = 0; i < number; i++) {
          var sec = Section(
            sectionNumber: '${i + 1 + questionnaire.sections.length}',
            title: 'Section ${i + 1 + questionnaire.sections.length} Title',
          );
          questionnaire.sections.add(sec);
        }
      }
    }
    setState(() {
      isBusy = false;
    });

    await Prefs.saveQuestionnaire(questionnaire);
    adminBloc.updateActiveQuestionnaire(questionnaire);
    Navigator.push(context, SlideRightRoute(
      widget: SectionEditor(questionnaire),
    ));
  }

  void _showErrorSnack(String s) {
    AppSnackbar.showErrorSnackbar(
        scaffoldKey: _key, message: s, actionLabel: 'Err', listener: this);
  }

  @override
  onActionPressed(int action) {
    return null;
  }
  void _writeQuestionnaireToDatabase() async {
    if (isBusy) return;
    setState(() {
      isBusy = true;
    });
    debugPrint('\n\n🦠 🦠 🦠 🦠 About to add  questionnaire to DB: 🦠 🦠 🦠 🦠 🦠 ');
    prettyPrint(questionnaire.toJson(), '... 🍎 🍎 🍎 about add this questionnaire to Mongo: 🍎 ');
    try {
      await adminBloc.addQuestionnaire(questionnaire);
      debugPrint(' 😍  😍  😍  remove active 💦 questionnaire from prefs after good write  😍 ');
      Prefs.removeQuestionnaire();
      setState(() {
        isBusy = false;
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
      _showErrorSnack(e.message);
    }
  }
}
