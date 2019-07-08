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

import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/slide_right.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/ui/signin.dart';
import 'package:orgadmin/admin_bloc.dart';
import 'package:orgadmin/ui/questionnaire/questionnaire_editor.dart';
import 'package:orgadmin/ui/settlement/settlements.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        primaryColor: Colors.teal,
        accentColor: Colors.pink
      ),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 36, fontWeight: FontWeight.w900);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Settlement',
      style: optionStyle,
    ),
    Text(
      'Questionnaire',
      style: optionStyle,
    ),
    Text(
      'Monitor',
      style: optionStyle,
    ),
    Text(
      'Project',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    switch(index) {
      case 0:
        Navigator.push(context, SlideRightRoute(
          widget: SettlementList(),
        ));
        break;
      case 1:
        Navigator.push(context, SlideRightRoute(
          widget: QuestionnaireEditor(),
        ));
        break;
      case 2:
//        Navigator.push(context, SlideRightRoute(
//          widget: SettlementList(),
//        ));
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
  }

  User user;
  Future _checkUser() async {
    var isOK = await AppAuth.isUserSignedIn();
    if (!isOK) {
      user = await  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return SignIn();
      }));
      print('🤟🤟🤟🤟🤟🤟🤟🤟 User returned from signIn');
      prettyPrint(user.toJson(), "User returned  🤟🤟🤟🤟🤟🤟🤟");
      adminBloc.setActiveUser();
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
      stream: adminBloc.activeUserStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          user = snapshot.data;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              user == null ? 'Digital Monitor Platform' : user.organizationName,
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
                      padding: const EdgeInsets.only(left:8.0, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.refresh, color: Colors.white,),
                            onPressed: _getData,)
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
                left: 28, top: 20,
                child: Image.asset('assets/hda.png', width: 48, height: 48, fit: BoxFit.fill,),
              ),
              ListView(
                children: <Widget>[
                  SizedBox(height: 80,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 100, width: 160,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 8,),
                                Text('${getFormattedNumber(settlements, context)}',
                                  style: Styles.purpleBoldLarge,),
                                SizedBox(height: 8,),
                                Text('Settlements'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100, width: 160,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 8,),
                                Text('${getFormattedNumber(projects, context)}',
                                  style: Styles.tealBoldLarge,),
                                SizedBox(height: 8,),
                                Text('Projects'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 100, width: 160,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 8,),
                                Text('${getFormattedNumber(questionnaires, context)}',
                                  style: Styles.pinkBoldLarge,),
                                SizedBox(height: 8,),
                                Text('Questionnaires'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100, width: 160,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 8,),
                                Text('${getFormattedNumber(users, context)}',
                                  style: Styles.blueBoldLarge,),
                                SizedBox(height: 8,),
                                Text('Users'),
                              ],
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
      }
    );
  }

  int settlements  = 0;
  int questionnaires = 0;
  int projects = 0;
  int users = 0;

  StreamSubscription<List<Settlement>> settSub;
  StreamSubscription<List<Questionnaire>> questSub;
  StreamSubscription<List<User>> userSub;
  StreamSubscription<List<Project>> projSub;
  void _subscribe() async {
    debugPrint('🏈 🏈 subscribe to data streams ...');
    settSub = adminBloc.settlementStream.listen((data) {
      setState(() {
        settlements = data.length;
      });
    });
    questSub = adminBloc.questionnaireStream.listen((data) {
      setState(() {
        questionnaires = data.length;
      });
    });
    userSub = adminBloc.usersStream.listen((data) {
      setState(() {
        users = data.length;
      });
    });
    projSub = adminBloc.projectStream.listen((data) {
      setState(() {
        projects = data.length;
      });
    });

  }
  void _getData() async {
    print('💊 💊 💊 get all settlements in country 📡  all org questionnaires 🎡  all org users +'
        ' 💈 all org  projects');
    var country = await Prefs.getCountry();
    if (country != null) {
      var list = await adminBloc.findSettlementsByCountry(country.countryId);
      settlements = list.length;
    }  else {
      print('country is NULL');
    }
    if (user != null) {
      var list = await adminBloc.findUsersByOrganization(user.organizationId);
      users = list.length;
      var list2 = await adminBloc.getQuestionnairesByOrganization(user.organizationId);
      questionnaires = list2.length;
    }
    print('🐳🐳 settlements: $settlements  🐳🐳 questionnaires: $questionnaires  🐳🐳 users: $users 🐳🐳 projects: $projects');
    setState(() {

    });
  }
  void _cancel() {
    settSub.cancel();
    questSub.cancel();
    userSub.cancel();
    projSub.cancel();
  }
}
