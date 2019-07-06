import 'package:flutter/material.dart';
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:monitorlibrary/snack.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> implements SnackBarListener {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Column(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 4,
          child: Column(
            children: <Widget>[
              Text(
                'Sign in',
                style: Styles.blackBoldLarge,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: _onEmailChanged,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter  email address',
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                onChanged: _onPasswordChanged,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: _signIn,
                color: Colors.pink[700],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Submit',
                    style: Styles.whiteSmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String email, password;
  void _onEmailChanged(String value) {
    email = value;
    print(email);
  }

  void _signIn() async {
    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key,
          message: "Data missing",
          actionLabel: 'Error',
          listener: this);
      return;
    }
    AppSnackbar.showSnackbarWithProgressIndicator(
        scaffoldKey: _key,
        message: "Signing in ...",
        textColor: Colors.white,
        backgroundColor: Colors.black);

    try {
      await AppAuth.signIn(email: email, password: password);
      Navigator.pop(context);
    } catch (e) {
      AppSnackbar.showErrorSnackbar(
          scaffoldKey: _key,
          message: e.message,
          actionLabel: 'Error',
          listener: this);
    }
  }

  void _onPasswordChanged(String value) {
    password = value;
    print(password);
  }

  @override
  onActionPressed(int action) {
    // TODO: implement onActionPressed
    return null;
  }
}
