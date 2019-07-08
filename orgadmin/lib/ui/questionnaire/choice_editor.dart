import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/question.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:orgadmin/admin_bloc.dart';

class ChoiceEditor extends StatefulWidget {
  final Question question;
  final Questionnaire questionnaire;
  ChoiceEditor(this.question, this.questionnaire);

  @override
  _ChoiceEditorState createState() => _ChoiceEditorState();
}

class _ChoiceEditorState extends State<ChoiceEditor>
    implements ChoiceFormListener {
  List<String> choices = List();
  TextEditingController textEditingController = TextEditingController();
  @override
  initState() {
    super.initState();
    choices = widget.question.choices;
    print('$choices choices found in question');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choices Editor'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          '${widget.question.text}',
                          style: Styles.whiteMedium,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 28,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '${choices.length}',
                            style: Styles.blackBoldLarge,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Choices',
                            style: Styles.whiteSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.brown[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: choices.length,
          itemBuilder: (BuildContext context, int index) {
            return ChoiceForm(choices.elementAt(index), index, this);
          },
        ),
      ),
    );
  }

  @override
  onTextChange(String text, int index) async {
    print('🐼 🐼 🐼 🐼 onTextChange: 🧩 $text for choice 🧩 #${index + 1} 🧩 will update active questionnaire');
    setState(() {
      choices[index] = text;
      widget.question.choices = choices;
    });

    await Prefs.saveQuestionnaire(widget.questionnaire);
    adminBloc.updateActiveQuestionnaire(widget.questionnaire);
  }
}

abstract class ChoiceFormListener {
  onTextChange(String text, int index);
}

class ChoiceForm extends StatefulWidget {
  final String choice;
  final int index;
  final ChoiceFormListener listener;
  ChoiceForm(this.choice, this.index, this.listener);

  @override
  _ChoiceFormState createState() => _ChoiceFormState();
}

class _ChoiceFormState extends State<ChoiceForm> {
  TextEditingController textEditingController = TextEditingController();
  String text;
  @override
  void initState() {
    super.initState();
    text = widget.choice;
    textEditingController.text = widget.choice;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) {
                widget.listener.onTextChange(value, widget.index);
              },
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Choice #${widget.index + 1} ',
                hintText: 'Enter Choice Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
