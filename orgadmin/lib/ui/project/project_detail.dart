import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/settlement.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/slide_right.dart';
import 'package:monitorlibrary/camera/gallery.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:orgadmin/ui/project/project_editor.dart';

class ProjectDetail extends StatefulWidget {
  final Project project;

  ProjectDetail(this.project);

  @override
  _ProjectDetailState createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  Project project;

  @override
  void initState() {
    super.initState();
    prettyPrint(widget.project.toJson(), '♻️ ♻️ ♻️ Project  ♻️♻️');
    project = widget.project;
    _getData();
  }

  _getData() async {
    _buildNav();
    user = await Prefs.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Project Details'),
        elevation: 8.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _onRefresh,
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: <Widget>[
                Text(
                  '${project.name}',
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '${project.description}',
                  style: Styles.whiteSmall,
                  overflow: TextOverflow.clip,
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.brown[50],
      body: Stack(
        children: <Widget>[
          isBusy
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 28.0, left: 8),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${getFormattedNumber(0, context)}',
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
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 140,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SlideRightRoute(
                                      widget: PhotoGallery(
                                        project: project,
                                      ),
                                    ));
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
                                        '${getFormattedNumber(project.photoUrls.length, context)}',
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
                                      '${getFormattedNumber(project.videoUrls.length, context)}',
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
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: project.settlements.isEmpty
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceEvenly,
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
                                      '${getFormattedNumber(project.ratings.length, context)}',
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
                          project.settlements.isEmpty
                              ? Container()
                              : Container(
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
                                            '${getFormattedNumber(project.settlements.length, context)}',
                                            style: Styles.blueBoldLarge,
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
                        ],
                      ),
                    ],
                  ),
                ),
          Positioned(
            left: 20,
            top: 20,
            child: Image.asset(
              'assets/hda.png',
              width: 64,
              height: 64,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        onTap: _navTapped,
      ),
    );
  }

  User user = User(userType: 'Administrator');
  bool isBusy = false;
  List<BottomNavigationBarItem> navItems = List();
  _buildNav() {
    navItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.create),
      title: Text('Edit'),
    ));
    navItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.brightness_auto),
      title: Text('Settlements'),
    ));
    navItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.map),
      title: Text('Map'),
    ));
  }

  void _navTapped(int value) {
    //todo - check usertype
    switch (value) {
      case 0:
        print('Questionnaire Nav  tapped');
        Navigator.push(
            context,
            SlideRightRoute(
              widget: ProjectEditor(
                project: widget.project,
              ),
            ));
        break;
      case 1:
        print('Project Nav  tapped');
        break;
      case 2:
        print('Map Nav  tapped');
//        Navigator.push(context, SlideRightRoute(
//          widget: MapEditor(widget.project),
//        ));
        break;
    }
  }

  void _onRefresh() async {
    try {
      debugPrint('✳️ ✳️ ✳️ ......  refresh project');
      project = await bloc.findProjectById(project.projectId);
      debugPrint('✳️ ✳️ ✳️ ......  refresh project done, set state ...');
      setState(() {});
    } catch (e) {
      AppSnackbar.showSnackbar(
          scaffoldKey: _key,
          message: e.message,
          textColor: Colors.white,
          backgroundColor: Colors.pink[900]);
    }
  }
}

class Basics extends StatelessWidget {
  final Settlement settlement;
  const Basics({
    Key key, this.settlement,
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
