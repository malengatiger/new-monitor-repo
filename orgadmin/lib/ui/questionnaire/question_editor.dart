import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/question.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/section.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:monitorlibrary/functions.dart' as prefix0;
import 'package:monitorlibrary/slide_right.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';
import 'package:orgadmin/ui/questionnaire/choice_editor.dart';

class QuestionEditor extends StatefulWidget {
  final Section section;
  final Questionnaire questionnaire;

  QuestionEditor(this.section, this.questionnaire);

  @override
  _QuestionEditorState createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> implements QuestionFormListener {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List<Question> questions = List();
  @override
  void initState() {
    super.initState();
    questions = widget.section.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Question Editor'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${widget.section.title}',
                    style: Styles.whiteBoldMedium,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '${questions.length}',
                        style: Styles.blackBoldLarge,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Questions',
                        style: Styles.whiteSmall,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.brown[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (BuildContext context, int index) {
            return QuestionForm(questions.elementAt(index), index, this, widget.questionnaire);
          },
        ),
      ),
    );
  }

  @override
  onQuestionChanged(Question question, int index) async {
    debugPrint('🦋🦋🦋 onQuestionChanged:  index $index  ');
    prettyPrint(question.toJson(), '🦋🦋🦋 Question after update, ☘☘ check if ok inside questionnaire');
    prettyPrint(widget.questionnaire.toJson(), '🐤 🐤 Questionnaire after question update, ☘☘ check  question');

    await  Prefs.saveQuestionnaire(widget.questionnaire);
    bloc.updateActiveQuestionnaire(widget.questionnaire);
    return null;
  }
}

class QuestionForm extends StatefulWidget {
  final Question question;
  final int index;
  final Questionnaire questionnaire;
  final QuestionFormListener listener;
  QuestionForm(this.question, this.index, this.listener, this.questionnaire);

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  TextEditingController textController = TextEditingController();
  TextEditingController countController = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.question.choices.forEach((m) {
      print('choice :  $m');
    });
    textController.text = widget.question.text;
    countController.text = '${widget.question.choices.length}';
    switch(widget.question.questionType) {
      case 'SingleAnswer':
        picked = 'Single Answer';
        break;
      case 'MultipleChoice':
        picked = 'Multiple Choice';
        isChoices = true;
        break;
      case 'SingleChoice':
        picked = 'Single Choice';
        isChoices = true;
        break;
    }
  }
  String picked;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: <Widget>[
          SizedBox(height: 12,),
          Text('Question ${widget.index + 1}', style: Styles.blackBoldMedium,),
          SizedBox(height: 12,),
          RadioButtonGroup(
            labels: <String>[
              'Single Answer',
              'Multiple Choice',
              'Single Choice',
            ],
            picked: picked,
            onChange: _onRadioButton,

          ),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left:16.0, right: 8),
            child: TextField(
              onChanged: _onTextChange,
              controller: textController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Question',
                hintText: 'Enter Question Text',
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: isChoices? Column(
              children: <Widget>[
                TextField(
                  onChanged: _onChoices,
                  controller: countController,
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Number of Choices',
                    hintText: 'Enter Number of Choices',
                  ),
                ),
                SizedBox(height: 24,),
                RaisedButton(
                  elevation: 4,
                  color: Colors.indigo,
                  onPressed: _navigateToChoiceEditor,
                  child: Text('Edit Choices', style: Styles.whiteSmall,),
                ),
              ],
            ): Container(),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool isChoices = false;
  String text = '';
  void _onTextChange(String value) {
    text = value;
    widget.question.text = text;
    widget.listener.onQuestionChanged(widget.question, widget.index);
  }

  void _onRadioButton(String label, int index) {
    print('🦕 🦕 🦕 🦕 _onRadioButton  $label index :  $index');
    switch (index) {
      case 0:
        widget.question.questionType = 'SingleAnswer';
        setState(() {
          isChoices = false;
        });
        break;
      case 1:
        widget.question.questionType = 'MultipleChoice';
        setState(() {
          isChoices = true;
        });
        break;
      case 2:
        widget.question.questionType = 'SingleChoice';
        setState(() {
          isChoices = true;
        });
        break;
    }
    widget.listener.onQuestionChanged(widget.question, widget.index);
  }

  int numberOfChoices = 0;
  void _onChoices(String value) {
    numberOfChoices = int.parse(value);
  }

  void _navigateToChoiceEditor() async {
    print('_navigateToChoiceEditor, 🚨 🚨 🚨 check choices ...');
    print(widget.question.choices);
    if (widget.question.choices == null || widget.question.choices.isEmpty) {
      List<String> list = List();
      for (var i = 0; i < numberOfChoices; i++) {
        list.add('Choice #${i + 1} - please edit');
      }
      widget.question.choices = list;
    } else {
      if (numberOfChoices > widget.question.choices.length) {
        var num = numberOfChoices - widget.question.choices.length;
        for (var i = 0; i < num; i++) {
          widget.question.choices.add('Choice #${i + 1 + numberOfChoices} - please edit');
        }
      }
    }

    await Prefs.saveQuestionnaire(widget.questionnaire);
    bloc.updateActiveQuestionnaire(widget.questionnaire);
    Navigator.push(context, SlideRightRoute(
      widget: ChoiceEditor(widget.question, widget.questionnaire),
    ));
  }
}

abstract class QuestionFormListener  {
  onQuestionChanged(Question question, int index);
}
