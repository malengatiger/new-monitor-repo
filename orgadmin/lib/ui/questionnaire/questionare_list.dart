import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:orgadmin/admin_bloc.dart';

class QuestionnaireList extends StatefulWidget {
  @override
  _QuestionnaireListState createState() => _QuestionnaireListState();
}

class _QuestionnaireListState extends State<QuestionnaireList> {
  List<Questionnaire> questionnaires = List();
  bool isBusy = false;
  User user;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    setState(() {
      isBusy = true;
    });
    user = await Prefs.getUser();
    if (user != null) {
      questionnaires =
          await adminBloc.getQuestionnairesByOrganization(user.organizationId);
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Questionnaire>>(
        stream: adminBloc.questionnaireStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            questionnaires = snapshot.data;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Organization Questionnaires'),
              backgroundColor: Colors.purple[300],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                  child: Text(
                            user == null ? '' : '${user.organizationName}',
                            style: Styles.blackBoldMedium,
                                    overflow: TextOverflow.clip,
                          ))),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                '${questionnaires.length}',
                                style: Styles.blackBoldLarge,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Questionnaires',
                                style: Styles.whiteSmall,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.brown[50],
            body: isBusy
                ? Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                        strokeWidth: 28,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: questionnaires.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.apps,  color: getRandomColor(),),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          '${questionnaires.elementAt(index).title}',
                                          style: Styles.blackBoldSmall,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 32,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          '${questionnaires.elementAt(index).description}',
                                          style: Styles.blackSmall,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
//                              ListTile(
//                                leading: Icon(Icons.apps),
//                                title: Text(
//                                  '${questionnaires.elementAt(index).title}',
//                                  style: Styles.blackBoldSmall,
//                                ),
//                                subtitle: Text(
//                                    '${questionnaires.elementAt(index).description}'),
//                              ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        });
  }
}
