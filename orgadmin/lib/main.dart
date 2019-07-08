// Flutter code sample for material.BottomNavigationBar.1

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/slide_right.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/ui/signin.dart';
import 'package:orgadmin/ui/questionnaire/questionnaire_editor.dart';
import 'package:orgadmin/ui/settlements.dart';

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
      'Settlements',
      style: optionStyle,
    ),
    Text(
      'Questionnaire',
      style: optionStyle,
    ),
    Text(
      'Monitors',
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
      Navigator.push(
          context,
          SlideRightRoute(
            widget: SignIn(),
          ));
      return;
    }
    user = await Prefs.getUser();
    if (user != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user == null ? 'Digital Monitor Platform' : user.organizationName,
          style: Styles.whiteBoldMedium,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
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
                SizedBox(height: 8,),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Settlements'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            title: Text('Questionnaire'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Monitors'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
