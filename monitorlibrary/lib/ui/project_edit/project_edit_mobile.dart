import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';
import 'package:monitorlibrary/ui/project_location/project_location_main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

class ProjectEditMobile extends StatefulWidget {
  final Project project;
  const ProjectEditMobile(this.project);

  @override
  _ProjectEditMobileState createState() => _ProjectEditMobileState();
}

class _ProjectEditMobileState extends State<ProjectEditMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var nameController = TextEditingController();
  var descController = TextEditingController();
  var maxController = TextEditingController(text: '50.0');
  var isBusy = false;

  User admin;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _setup();
    _getUser();
  }

  void _getUser() async {
    admin = await Prefs.getUser();
    pp('🎽 🎽 🎽 We have an admin user? 🎽 🎽 🎽 ${admin.toJson()}');
    setState(() {});
  }

  void _setup() {
    if (widget.project != null) {
      nameController.text = widget.project.name;
      descController.text = widget.project.description;
      maxController.text = '${widget.project.monitorMaxDistanceInMetres}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isBusy = true;
      });
      try {
        Project mProject;
        if (widget.project == null) {
          pp('😡 😡 😡 _submit new project ......... ${nameController.text}');
          var uuid = Uuid();
          mProject = Project(
              name: nameController.text,
              description: descController.text,
              organizationId: admin.organizationId,
              organizationName: admin.organizationName,
              created: DateTime.now().toIso8601String(),
              monitorMaxDistanceInMetres: double.parse(maxController.text),
              projectId: uuid.v4());
          var m = await adminBloc.addProject(mProject);
          pp('🎽 🎽 🎽 _submit: new project added .........  ${m.toJson()}');
        } else {
          pp('😡 😡 😡 _submit existing project for update, soon! 🌸 ......... ');
          widget.project.name = nameController.text;
          widget.project.description = descController.text;
          mProject = widget.project;
          var m = await adminBloc.updateProject(widget.project);
          pp('🎽 🎽 🎽 _submit: new project updated .........  ${m.toJson()}');
        }
        setState(() {
          isBusy = false;
        });
        monitorBloc.getOrganizationProjects(
            organizationId: mProject.organizationId);
        _navigateToProjectLocation(mProject);
      } catch (e) {
        setState(() {
          isBusy = false;
        });

        AppSnackbar.showErrorSnackbar(
            scaffoldKey: _key, message: 'Failed: $e', actionLabel: '');
      }
    }
  }

  void _navigateToProjectLocation(Project mProject) async {
    if (mProject == null) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key, message: 'Project is missing', actionLabel: '');
      return;
    }
    pp(' 😡 _navigateToProjectLocation  😡 😡 😡 ${mProject.name}');
    await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            alignment: Alignment.bottomRight,
            duration: Duration(seconds: 1),
            child: ProjectLocationMain(mProject)));
    Navigator.pop(context);
  }

  var _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            'Project Editor',
            style: Styles.whiteSmall,
          ),
          actions: [
            widget.project == null
                ? Container()
                : IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      if (widget.project != null) {
                        _navigateToProjectLocation(widget.project);
                      }
                    },
                  )
          ],
          bottom: PreferredSize(
            child: Column(
              children: [
                Text(
                  widget.project == null ? 'New Project' : 'Edit Project',
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  admin == null ? '' : '${admin.organizationName}',
                  style: Styles.whiteSmall,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            preferredSize: Size.fromHeight(100),
          ),
        ),
        backgroundColor: Colors.brown[100],
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.event,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Project Name',
                            hintText: 'Enter Project Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Project name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: descController,
                        keyboardType: TextInputType.multiline,
                        minLines: 2, //Normal textInputField will be displayed
                        maxLines:
                            6, // when user presses enter it will adapt to it
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.info_outline,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Description',
                            hintText: 'Enter Project Description'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Project Description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: maxController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.camera_enhance_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Max Monitor Distance in Metres',
                            hintText:
                                'Enter Maximum Monitor Distance in metres'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Maximum Monitor Distance in Metres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 48,
                      ),
                      isBusy
                          ? Container(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                                backgroundColor: Colors.black,
                              ),
                            )
                          : Column(
                              children: [
                                widget.project == null
                                    ? Container()
                                    : Container(
                                        width: 220,
                                        child: RaisedButton(
                                          elevation: 8,
                                          color: Theme.of(context).accentColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              'Add Location',
                                              style: Styles.whiteSmall,
                                            ),
                                          ),
                                          onPressed: () {
                                            _navigateToProjectLocation(
                                                widget.project);
                                          },
                                        ),
                                      ),
                                widget.project == null
                                    ? Container()
                                    : SizedBox(
                                        height: 20,
                                      ),
                                Container(
                                  width: 220,
                                  child: RaisedButton(
                                    elevation: 8,
                                    color: Theme.of(context).primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        'Submit Project',
                                        style: Styles.whiteSmall,
                                      ),
                                    ),
                                    onPressed: _submit,
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
