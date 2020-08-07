import 'package:flutter/material.dart';
import 'package:monitorlibrary/data/community.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:orgadmin2/ui/map_editor.dart';
import 'package:orgadmin2/ui/questionnaire/questionnaire_editor.dart';
import 'package:page_transition/page_transition.dart';

class SettlementDetail extends StatefulWidget {
  final Community settlement;

  SettlementDetail(this.settlement);

  @override
  _SettlementDetailState createState() => _SettlementDetailState();
}

class _SettlementDetailState extends State<SettlementDetail> {
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    prettyPrint(widget.settlement.toJson(), '♻️ ♻️ ♻️ Settlement  ♻️♻️');
    _getData();
  }

  _getData() async {
    _buildNav();
  }

  @override
  Widget build(BuildContext context) {
    var community = widget.settlement;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Settlement Details'),
        elevation: 8.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Column(
            children: <Widget>[
              Text(
                '${community.name}',
                style: Styles.blackBoldMedium,
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.brown[50],
      body: isBusy
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  new Basics(
                    settlement: community,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                    elevation: 4,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${getFormattedNumber(community.photoUrls.length, context)}',
                            style: Styles.blackBoldLarge,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Questionnaires'),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 140,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${getFormattedNumber(community.photoUrls.length, context)}',
                                  style: Styles.purpleBoldLarge,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Photos'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 140,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${getFormattedNumber(community.photoUrls.length, context)}',
                                  style: Styles.tealBoldLarge,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Videos'),
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
                        width: 140,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${getFormattedNumber(community.ratings.length, context)}',
                                  style: Styles.pinkBoldLarge,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text('Ratings'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 140,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${getFormattedNumber(community.ratings.length, context)}',
                                  style: Styles.blueBoldLarge,
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
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        onTap: _navTapped,
      ),
    );
  }

  bool isBusy = false;
  List<BottomNavigationBarItem> navItems = List();
  _buildNav() {
    navItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.create),
      title: Text('Questionnaires'),
    ));
    navItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.brightness_auto),
      title: Text('Projects'),
    ));
    navItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.map),
      title: Text('Map'),
    ));
  }

  void _navTapped(int value) {
    switch (value) {
      case 0:
        print('Questionnaire Nav  tapped');
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.topLeft,
                duration: Duration(seconds: 1),
                child: QuestionnaireEditor()));

        break;
      case 1:
        print('Project Nav  tapped');
        break;
      case 2:
        print('Map Nav  tapped');
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.topLeft,
                duration: Duration(seconds: 1),
                child: MapEditor(widget.settlement)));

        break;
    }
  }
}

class Basics extends StatelessWidget {
  final Community settlement;
  const Basics({
    Key key,
    @required this.settlement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Text('${settlement.email}'),
          SizedBox(
            height: 8,
          ),
          Text('${settlement.countryName}'),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Population'),
              SizedBox(
                width: 12,
              ),
              Text(
                '${getFormattedNumber(settlement.population, context)}',
                style: Styles.blackBoldMedium,
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
