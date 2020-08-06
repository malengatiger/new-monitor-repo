import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/ui/questionare_list.dart';
import 'package:monitorlibrary/ui/settlement_list.dart';
import 'package:monitorlibrary/ui/signin.dart';
import 'package:page_transition/page_transition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.indigo,
          accentColor: Colors.pink,
          fontFamily: 'Raleway',
          backgroundColor: Colors.brown[100]),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    implements SettlementListener, QuestionnaireListener {
  bool isBusy = false;
  @override
  initState() {
    print('🍎🍎🍎 Monitor main initState fired! 💙💙💙');
    super.initState();
    _checkUser();
  }

  User user;
  Future _checkUser() async {
    print('💙💙💙 Monitor checking if user is authenticated ... 💙💙💙');
    var isOK = await AppAuth.isUserSignedIn();
    if (!isOK) {
      print(
          '🔆🔆🔆 This monitor user is not authenticated yet ... 🔆🔆🔆🔆 starting sign in ... 🔆🔆🔆🔆');
      user = await Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.scale,
              alignment: Alignment.topLeft,
              duration: Duration(seconds: 2),
              child: SignIn('MONITOR')));
      if (user != null) {
        print('🤟🤟🤟🤟🤟🤟🤟🤟 User returned from signIn');
        prettyPrint(user.toJson(), "User returned  🤟🤟🤟🤟🤟🤟🤟");
        bloc.setActiveUser();
      }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(user == null
            ? 'Digital Monitor Platform'
            : '${user.organizationName}'),
        backgroundColor: Colors.deepOrange[300],
        elevation: 8,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  user == null ? '' : '${user.firstName} ${user.lastName}',
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  user == null ? '' : '${user.userType}',
                  style: Styles.whiteSmall,
                ),
                SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          'This app is used only for the purposes of the HDA and not for personal entertainment ',
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _getData,
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
      ),
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 28,
            top: 28,
            child: Image.asset(
              'assets/hda.png',
              width: 48,
              height: 48,
              fit: BoxFit.fill,
            ),
          ),
          isBusy
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 24,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                )
              : ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
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
                                  PageTransition(
                                      type: PageTransitionType.scale,
                                      alignment: Alignment.topLeft,
                                      duration: Duration(seconds: 2),
                                      child: SettlementList(this)));
                            },
                            child: Card(
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
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 160,
                          child: Card(
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
                                  PageTransition(
                                      type: PageTransitionType.scale,
                                      alignment: Alignment.topLeft,
                                      duration: Duration(seconds: 2),
                                      child: QuestionnaireList(this)));
                            },
                            child: Card(
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library), title: Text('Send')),
          BottomNavigationBarItem(
              icon: Icon(Icons.description), title: Text('Report')),
        ],
        onTap: _onNavTap,
      ),
    );
  }

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
    setState(() {
      isBusy = true;
    });
    var country = await Prefs.getCountry();
    if (country != null) {
      var list = await bloc.findSettlementsByCountry(country.countryId);
      settlements = list.length;
    } else {
      print('country is NULL');
    }
    if (user != null) {
      var list2 =
          await bloc.getQuestionnairesByOrganization(user.organizationId);
      questionnaires = list2.length;
      var list3 = await bloc.findProjectsByOrganization(user.organizationId);
      projects = list3.length;
    }
    print(
        '🐳🐳 settlements: $settlements  🐳🐳 questionnaires: $questionnaires  🐳🐳 🐳🐳 projects: $projects');
    setState(() {
      isBusy = false;
    });
  }

  int settlements = 0;
  int questionnaires = 0;
  int projects = 0;

  void _onNavTap(int value) {
    switch (value) {
      case 0:
        print('First nav tapped: $value');
        break;
      case 1:
        print('Secons nav tapped: $value');
        break;
    }
  }

  void _cancel() {
    settSub.cancel();
    questSub.cancel();
    userSub.cancel();
    projSub.cancel();
  }

  @override
  onSettlementSelected(Settlement settlement) {
    // TODO: implement onSettlementSelected
    return null;
  }

  @override
  onQuestionnaireSelected(Questionnaire questionnaire) {
    // TODO: implement onQuestionnaireSelected
    return null;
  }
}
