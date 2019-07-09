import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/slide_right.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:orgadmin/admin_bloc.dart';
import 'package:orgadmin/ui/camera/camera_ui.dart';

class ProjectEditor extends StatefulWidget {
  final Project project;

  ProjectEditor({this.project});

  @override
  _ProjectEditorState createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor>
    implements SnackBarListener {
  User user;
  Project mProject;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isBusy = false;
  GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    user = await Prefs.getUser();
    mProject = widget.project;
    if (mProject == null) {
      mProject = Project(
        organizationName: user.organizationName,
        organizationId: user.organizationId,
        settlements: [],
        positions: [],
        photoUrls: [],
        videoUrls: [],
        ratings: [],
        nearestCities: [],
      );
    } else {
      nameController.text = mProject.name;
      descController.text = mProject.description;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Project Editor'),
        backgroundColor: Colors.purple[300],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  user == null ? '' : '${user.organizationName}',
                  style: Styles.whiteBoldMedium,
                  overflow: TextOverflow.clip,
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.brown[100],
      body: isBusy
          ? Center(
              child: Container(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 24,
                  backgroundColor: Colors.teal,
                ),
              ),
            )
          : Padding(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Project Details',
                      style: Styles.blackBoldLarge,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Project Name',
                        labelText: 'Project Name',
                      ),
                      onChanged: _onNameChanged,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: descController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter Project Description',
                        labelText: 'Description',
                      ),
                      onChanged: _onDescChanged,
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    RaisedButton(
                      elevation: 8,
                      color: Colors.indigo,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24.0, top: 20, bottom: 20),
                        child: Text(
                          'Submit Project',
                          style: Styles.whiteSmall,
                        ),
                      ),
                      onPressed: _submit,
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.camera), title: Text('Camera')),
        BottomNavigationBarItem(icon: Icon(Icons.local_library), title: Text('Rating')),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), title: Text('Location')),
      ],
      onTap: _onNavTapped,),
    );
  }

  void _onNameChanged(String value) {
    mProject.name = value;
  }

  void _onDescChanged(String value) {
    mProject.description = value;
  }

  _submit() async {
    setState(() {
      isBusy = true;
    });
    if (mProject.name == null || mProject.name.isEmpty) {
      _showError('Please enter Project name');
      return;
    }
    if (mProject.description == null || mProject.description.isEmpty) {
      _showError('Please enter Project description');
      return;
    }
    try {
      mProject = await adminBloc.addProject(mProject);
      prettyPrint(mProject.toJson(), '🍉 PROJECT added to database. 🍉 🍉 🍉 check projectId');
    } catch (e) {
      print(e);
      _showError(e.message);
    }
    setState(() {
      isBusy = false;
    });
    AppSnackbar.showSnackbar(
        scaffoldKey: _key,
        message: 'Project added',
        textColor: Colors.lightBlue,
        backgroundColor: Colors.black);
  }

  _showError(String message) {
    AppSnackbar.showErrorSnackbar(
        scaffoldKey: _key,
        message: message,
        actionLabel: 'Error',
        listener: this);
  }

  @override
  onActionPressed(int action) {
    return null;
  }

  void _onNavTapped(int value) {
    if  (mProject.projectId == null || mProject.projectId.isEmpty) {
      debugPrint('👎 👎 👎 NavTapped - project not ready yet');
      return;
    }
    switch(value) {
      case 0:
        Navigator.push(context, SlideRightRoute(
          widget: CameraMain(project: mProject,),
        ));
        break;
    }

  }
}
