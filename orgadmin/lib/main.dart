// Flutter code sample for material.BottomNavigationBar.1

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/Constants.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/slide_right.dart';
import 'package:monitorlibrary/ui/project_list.dart';
import 'package:monitorlibrary/ui/questionare_list.dart';
import 'package:monitorlibrary/ui/settlement_list.dart';
import 'package:monitorlibrary/ui/signin.dart';
import 'package:orgadmin/ui/project/project_detail.dart';
import 'package:orgadmin/ui/project/project_editor.dart';
import 'package:orgadmin/ui/questionnaire/questionnaire_editor.dart';
import 'package:orgadmin/ui/settlement/settlement_detail.dart';
import 'package:orgadmin/ui/settlement/settlement_editor.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: '', primaryColor: Colors.indigo[300]),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    implements ProjectListener, SettlementListener, QuestionnaireListener {
  int _selectedIndex = 0;
  GeneralBloc bloc = GeneralBloc();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  StreamSubscription userSubscription,
      projectSubscription,
      questionnaireSubscription,
      settSubscription,
      orgSubscription;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            SlideRightRoute(
              widget: SettlementEditor(),
            ));
        break;
      case 1:
        Navigator.push(
            context,
            SlideRightRoute(
              widget: QuestionnaireEditor(),
            ));
        break;
      case 2:
        Navigator.push(
            context,
            SlideRightRoute(
              widget: ProjectEditor(),
            ));
        break;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  initState() {
    super.initState();
    _checkUser();
    initialize();
  }

  subscribe() async {
    debugPrint(
        '\n\n🍏🍏 💙💙💙 💙💙💙 Inside Dashboard: Subscribe to FCM topics ... 💙💙💙💙💙💙 🍏🍏');
    await firebaseMessaging.subscribeToTopic(Constants.TOPIC_USERS);
    await firebaseMessaging.subscribeToTopic(Constants.TOPIC_SETTLEMENTS);
    await firebaseMessaging.subscribeToTopic(Constants.TOPIC_PROJECTS);
    await firebaseMessaging.subscribeToTopic(Constants.TOPIC_QUESTIONNAIRES);
    await firebaseMessaging.subscribeToTopic(Constants.TOPIC_ORGANIZATIONS);
    debugPrint(
        '💙💙💙 🍎🍎🍎🍎 Inside Dashboard: Subscriptions to FCM topics completed. 🍎🍎🍎🍎🍎🍎');
    debugPrint(
        '🔆🔆🔆🔆 topics: 🔆 ${Constants.TOPIC_USERS} 🔆 ${Constants.TOPIC_SETTLEMENTS} 🔆 ${Constants.TOPIC_PROJECTS} 🔆 ${Constants.TOPIC_ORGANIZATIONS} 🔆 ${Constants.TOPIC_QUESTIONNAIRES} 🔆🔆🔆🔆 \n\n');
  }

  Country country;
  initialize() async {
    debugPrint(
        "🍎🍎🍎🍎 Inside Dashboard: initialize: Setting up FCM messaging 🧡💛🧡💛 configurations & streams: 🧡💛 ${DateTime.now().toIso8601String()}");
    country = await Prefs.getCountry();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        var data = message['data'];
        print(
            "🍏🍏 Inside Dashboard: 🍏🍏 onMessage: 🍏🍏 type: 🔵 ${data['type']} 🔵 🧡🧡🧡 $message 🍎🍎🍎");
        String type = data['type'];
//        switch (type) {
//          case Constants.MESSAGE_USER:
//            print('🏈 🏈 🏈 Received message of type 🍎 $type 🍎 ');
//            bloc.findUsersByOrganization(user.organizationId);
//            break;
//          case Constants.MESSAGE_SETTLEMENT:
//            print('🏈 🏈 🏈 Received message of type 🍎 $type 🍎 ');
//            bloc.findSettlementsByCountry(country.countryId);
//            break;
//          case Constants.MESSAGE_PROJECT:
//            print('🏈 🏈 🏈 Received message of type 🍎 $type 🍎 ');
//            bloc.findProjectsByOrganization(user.organizationId);
//            break;
//          case Constants.MESSAGE_QUESTIONNAIRE:
//            print('🏈 🏈 🏈 Received message of type 🍎 $type 🍎 ');
//            bloc.getQuestionnairesByOrganization(user.organizationId);
//            break;
//          case Constants.MESSAGE_ORGANIZATION:
//            print('🏈 🏈 🏈 Received message of type 🍎 $type 🍎 ');
//
//            break;
//        }
        print('🏈 🏈 🏈 Received message of type 🍎 $type 🍎 ');
        if (type == Constants.TOPIC_USERS) {
          bloc.findUsersByOrganization(user.organizationId);
          return;
        }
        if (type == Constants.TOPIC_SETTLEMENTS) {
          bloc.findSettlementsByCountry(country.countryId);
          return;
        }
        if (type == Constants.TOPIC_PROJECTS) {
          bloc.findProjectsByOrganization(user.organizationId);
          return;
        }
        if (type == Constants.TOPIC_QUESTIONNAIRES) {
          bloc.getQuestionnairesByOrganization(user.organizationId);
          return;
        }
        print(
            '🔆🔆🔆🔆 We CANNOT see the type of message, 🔆🔆🔆🔆 rather cannot compare to constants');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("🍏🍏 🍏🍏 onLaunch: $message 🧡💛");
      },
      onResume: (Map<String, dynamic> message) async {
        print("🍏🍏 🍏🍏 onResume: $message");
      },
    );
    var token = await firebaseMessaging.getToken();
    debugPrint(
        '🧩🧩🧩🧩🧩🧩 Inside Dashboard: FCM token: 🧩🧩🧩🧩🧩🧩🧩🧩 🐥🐥🐥🐥🐥 $token 🐥🐥🐥🐥🐥');
    subscribe();
  }

  @override
  dispose() {
    super.dispose();
    userSubscription.cancel();
    projectSubscription.cancel();
    questionnaireSubscription.cancel();
    settSubscription.cancel();
    orgSubscription.cancel();
  }

  User user;
  Future _checkUser() async {
    var isOK = await AppAuth.isUserSignedIn();
    if (!isOK) {
      user = await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SignIn();
      }));
      print('🤟🤟🤟🤟🤟🤟🤟🤟 User returned from signIn');
      prettyPrint(user.toJson(), "User returned  🤟🤟🤟🤟🤟🤟🤟");
      bloc.setActiveUser();
    }
    user = await Prefs.getUser();
    if (user != null) {
      setState(() {});
      _subscribe();
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: bloc.activeUserStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                user == null
                    ? 'Digital Monitor Platform'
                    : user.organizationName,
                style: Styles.whiteBoldMedium,
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            user == null
                                ? 'Administrator'
                                : '${user.firstName} ${user.lastName}',
                            style: Styles.blackBoldMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            user == null
                                ? 'Administrator'
                                : '${user.userType} ',
                            style: Styles.whiteSmall,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              onPressed: _getData,
                            )
                          ],
                        ),
                      ),
//                    SizedBox(height: 8,),
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.brown[50],
            body: Stack(
              children: <Widget>[
                Positioned(
                  left: 28,
                  top: 20,
                  child: Image.asset(
                    'assets/hda.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.fill,
                  ),
                ),
                ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 160,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                    widget: SettlementList(this),
                                  ));
                            },
                            child: StreamBuilder<List<Settlement>>(
                                stream: bloc.settlementStream,
                                initialData: List(),
                                builder: (context, snapshot) {
                                  debugPrint(
                                      '💙💙💙 bloc.settlementStream: 💙 ${snapshot.data.length} 💙');
                                  if (snapshot.hasData) {
                                    settlements = snapshot.data.length;
                                  }
                                  return Card(
                                    elevation: 4,
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '${getFormattedNumber(settlements, context)}',
                                            style: Styles.purpleBoldLarge,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text('Settlements'),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 160,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                    widget: ProjectList(this),
                                  ));
                            },
                            child: StreamBuilder<List<Project>>(
                                stream: bloc.projectStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    debugPrint(
                                        '💙💙💙 bloc.projectStream: 💙 ${snapshot.data.length} 💙');
                                    projects = snapshot.data.length;
                                  }
                                  return Card(
                                    elevation: 4,
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '${getFormattedNumber(projects, context)}',
                                            style: Styles.tealBoldLarge,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text('Projects'),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 160,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      widget: QuestionnaireList(this)));
                            },
                            child: StreamBuilder<List<Questionnaire>>(
                                stream: bloc.questionnaireStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    debugPrint(
                                        '💙💙💙 bloc.questionnaireStream: 💙 ${snapshot.data.length} 💙');
                                    questionnaires = snapshot.data.length;
                                  }
                                  return Card(
                                    elevation: 4,
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            '${getFormattedNumber(questionnaires, context)}',
                                            style: Styles.pinkBoldLarge,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text('Questionnaires'),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 160,
                          child: StreamBuilder<List<User>>(
                              stream: bloc.usersStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  debugPrint(
                                      '💙💙💙 bloc.usersStream: 💙 ${snapshot.data.length} 💙');
                                  users = snapshot.data.length;
                                }
                                return Card(
                                  elevation: 4,
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${getFormattedNumber(users, context)}',
                                          style: Styles.blueBoldLarge,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text('Users'),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Settlement'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.create),
                  title: Text('Questionnaire'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.apps),
                  title: Text('Project'),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.pink[800],
              onTap: _onItemTapped,
            ),
          );
        });
  }

  int settlements = 0;
  int questionnaires = 0;
  int projects = 0;
  int users = 0;

  StreamSubscription<List<Settlement>> settSub;
  StreamSubscription<List<Questionnaire>> questSub;
  StreamSubscription<List<User>> userSub;
  StreamSubscription<List<Project>> projSub;
  void _subscribe() async {
    debugPrint('🏈 🏈 subscribe to data streams ...');
    settSub = bloc.settlementStream.listen((data) {
      setState(() {
        settlements = data.length;
      });
    });
    questSub = bloc.questionnaireStream.listen((data) {
      setState(() {
        questionnaires = data.length;
      });
    });
    userSub = bloc.usersStream.listen((data) {
      setState(() {
        users = data.length;
      });
    });
    projSub = bloc.projectStream.listen((data) {
      setState(() {
        projects = data.length;
      });
    });
  }

  void _getData() async {
    print(
        '💊 💊 💊 get all settlements in country 📡  all org questionnaires 🎡  all org users +'
        ' 💈 all org  projects');
    var country = await Prefs.getCountry();
    if (country == null) {
      var countries = await bloc.getCountries();
      if (countries.isNotEmpty) {
        country = countries.elementAt(0);
      }
    }
    if (country != null) {
      var list = await bloc.findSettlementsByCountry(country.countryId);
      settlements = list.length;
    } else {
      print('😈😈😈😈😈😈 country is NULL 😈😈😈😈  WTF???');
    }
    if (user != null) {
      var list = await bloc.findUsersByOrganization(user.organizationId);
      users = list.length;
      var list2 =
          await bloc.getQuestionnairesByOrganization(user.organizationId);
      questionnaires = list2.length;
      var list3 = await bloc.findProjectsByOrganization(user.organizationId);
      projects = list3.length;
    }
    print(
        '🐳🐳 settlements: $settlements  🐳🐳 questionnaires: $questionnaires  🐳🐳 users: $users 🐳🐳 projects: $projects');
    setState(() {});
  }

  void cancel() {
    settSub.cancel();
    questSub.cancel();
    userSub.cancel();
    projSub.cancel();
  }

  @override
  onProjectSelected(Project project) {
    debugPrint('Main:  🤕 🤕 onProjectSelected: 🍑 project has  been selected');
    prettyPrint(project.toJson(), '🍑 🍑 🍑  SELECTED PROJECT');
    Navigator.push(
        context,
        SlideRightRoute(
          widget: ProjectDetail(
            project,
          ),
        ));
  }

  @override
  onSettlementSelected(Settlement settlement) {
    debugPrint(
        'Main:  🤕 🤕 onSettlementSelected: 🍑 settlement has  been selected');
    prettyPrint(settlement.toJson(), '🍑 🍑 🍑  SELECTED SETTLEMENT');
    Navigator.push(
        context,
        SlideRightRoute(
          widget: SettlementDetail(
            settlement,
          ),
        ));
  }

  @override
  onQuestionnaireSelected(Questionnaire questionnaire) {
    debugPrint(
        'Main:  🤕 🤕 onQuestionnaireSelected: 🍑 questionnaire has  been selected');
    prettyPrint(questionnaire.toJson(), '🍑 🍑 🍑  SELECTED QUESTIONNAIRE');
    Navigator.push(
        context,
        SlideRightRoute(
          widget: QuestionnaireEditor(
            questionnaire: questionnaire,
          ),
        ));
  }
}
