import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';

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
  }

  void _setup() {
    if (widget.project != null) {
      nameController.text = widget.project.name;
      descController.text = widget.project.description;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      if (widget.project == null) {
        pp('😡 😡 😡 _submit new project ......... ${nameController.text}');
        var user = Project(
            name: nameController.text,
            description: descController.text,
            organizationId: admin.organizationId,
            organizationName: admin.organizationName,
            created: DateTime.now().toIso8601String(),
            projectId: '');

        await adminBloc.addProject(user);
      } else {
        pp('😡 😡 😡 _submit existing project for update, soon! 🌸 ......... ');
        widget.project.name = nameController.text;
        widget.project.description = descController.text;

        await adminBloc.updateProject(widget.project);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'User Editor',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            child: Column(
              children: [
                Text(
                  widget.project == null ? 'New User' : 'Edit User',
                  style: Styles.blackBoldMedium,
                ),
                SizedBox(
                  height: 40,
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
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Organization Name',
                            hintText: 'Enter Organization Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Organization name';
                          }
                          return value;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        controller: descController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email_outlined),
                            labelText: 'Description',
                            hintText: 'Enter Project Description'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Project Description';
                          }
                          return value;
                        },
                      ),
                      SizedBox(
                        height: 48,
                      ),
                      RaisedButton(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Submit Project',
                            style: Styles.whiteSmall,
                          ),
                        ),
                        onPressed: _submit,
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
