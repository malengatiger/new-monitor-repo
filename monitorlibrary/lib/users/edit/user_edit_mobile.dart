import 'package:flutter/material.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/bloc/admin_bloc.dart';
import 'package:monitorlibrary/bloc/monitor_bloc.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';

class UserEditMobile extends StatefulWidget {
  final User user;
  const UserEditMobile(this.user);

  @override
  _UserEditMobileState createState() => _UserEditMobileState();
}

class _UserEditMobileState extends State<UserEditMobile>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cellphoneController = TextEditingController();
  User admin;
  final _formKey = GlobalKey<FormState>();
  var _key = GlobalKey<ScaffoldState>();
  var isBusy = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _setup();
    _getUser();
  }

  void _getUser() async {
    admin = await Prefs.getUser();
    setState(() {});
  }

  void _setup() {
    if (widget.user != null) {
      nameController.text = widget.user.name;
      emailController.text = widget.user.email;
      cellphoneController.text = widget.user.cellphone;
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
        if (widget.user == null) {
          var user = User(
              name: nameController.text,
              email: emailController.text,
              cellphone: cellphoneController.text,
              organizationId: admin.organizationId,
              organizationName: admin.organizationName,
              userType: type,
              created: DateTime.now().toIso8601String(),
              userId: 'tbd');
          pp('😡 😡 😡 _submit new user ......... ${user.toJson()}');
          await AppAuth.createUser(user, 'pass123');
          monitorBloc.getOrganizationUsers(organizationId: user.organizationId);
        } else {
          widget.user.name = nameController.text;
          widget.user.email = emailController.text;
          widget.user.cellphone = cellphoneController.text;
          widget.user.userType = type;
          pp('😡 😡 😡 _submit existing user for update, soon! 🌸 ......... ${widget.user.toJson()}');
          await adminBloc.updateUser(widget.user);
          monitorBloc.getOrganizationUsers(
              organizationId: widget.user.organizationId);
        }

        Navigator.pop(context);
      } catch (e) {
        AppSnackbar.showErrorSnackbar(
            scaffoldKey: _key, message: 'Failed : $e');
      }
      setState(() {
        isBusy = false;
      });
    }
  }

  int userType = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            'User Editor',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
            child: Column(
              children: [
                Text(
                  widget.user == null ? 'New User' : 'Edit User',
                  style: Styles.blackBoldMedium,
                ),
                admin == null
                    ? Container()
                    : SizedBox(
                        height: 8,
                      ),
                Text(
                  admin == null ? '' : admin.organizationName,
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
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                            hintText: 'Enter Full Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email_outlined),
                            labelText: 'Email Address',
                            hintText: 'Enter Email Address'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        controller: cellphoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            icon: Icon(Icons.phone),
                            labelText: 'Cellphone',
                            hintText: 'Cellphone'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter cellphone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.user == null
                          ? TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  labelText: 'Password',
                                  hintText: 'Password'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: userType,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text(
                            'Monitor',
                            style: Styles.blackTiny,
                          ),
                          Radio(
                            value: 1,
                            groupValue: userType,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text('Admin', style: Styles.blackTiny),
                          Radio(
                            value: 2,
                            groupValue: userType,
                            onChanged: _handleRadioValueChange,
                          ),
                          Text(
                            'Executive',
                            style: Styles.blackTiny,
                          ),
                        ],
                      ),
                      Text(
                        type == null ? '' : type,
                        style: Styles.greyLabelSmall,
                      ),
                      SizedBox(
                        height: 16,
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
                          : RaisedButton(
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Submit User',
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

  String type;
  void _handleRadioValueChange(Object value) {
    pp('🌸 🌸 🌸 🌸 🌸 _handleRadioValueChange: 🌸 $value');
    setState(() {
      switch (value) {
        case 0:
          type = FIELD_MONITOR;
          userType = 0;
          break;
        case 1:
          type = ORG_ADMINISTRATOR;
          userType = 1;
          break;
        case 2:
          type = ORG_EXECUTIVE;
          userType = 2;
          break;
      }
    });
  }
}
