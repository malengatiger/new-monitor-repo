import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/user.dart' as mon;

import '../functions.dart';

class AppAuth {
  static FirebaseAuth _auth;

  static Future<bool> isUserSignedIn() async {
    pp('🥦 🥦  😎😎😎😎 AppAuth: isUserSignedIn :: 😎😎😎 about to initialize Firebase; 😎');
    await Firebase.initializeApp();
    pp('😎😎😎😎 AppAuth: isUserSignedIn :: 😎😎😎 Firebase has been initialized; 😎 or not? 🍀🍀');
    _auth = FirebaseAuth.instance;
    var authUser = _auth.currentUser;
    var user = await Prefs.getUser();
    if (authUser == null) {
      return false;
    } else {
      if (user != null) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future createUser(mon.User user, String password) async {
    var fbUser = await _auth
        .createUserWithEmailAndPassword(email: user.email, password: password)
        .catchError((e) {
      pp('User create failed');
    });
    if (fbUser != null) {
      var mUser = await DataAPI.addUser(user);
      await Prefs.saveUser(mUser);
      var countries = await DataAPI.getCountries();
      if (countries.isNotEmpty) {
        await Prefs.saveCountry(countries.elementAt(0));
      }
    }
  }

  static Future signIn(String email, String password, String type) async {
    pp('🔐🔐🔐🔐 Auth signing in $email - $password  🔐🔐🔐🔐');
    var fbUser = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      pp('👿👿👿 Firebase sign in failed, 👿 message below');
      pp(e);
      throw e;
    });
    if (fbUser != null) {
      pp('🔐🔐🔐🔐 Auth finding user by email $email 🔐🔐🔐🔐');
      var user = await DataAPI.findUserByEmail(fbUser.user.email);
      if (user == null) {
        pp('👎🏽 👎🏽 👎🏽 User not registered yet 👿');
        throw Exception("User not found 👿 👿 👿 ");
      }
      if (user.userType != type) {
        pp('👎🏽 👎🏽 👎🏽 There is a fuck up somewhere, user type is WRONG! 👿');
        throw Exception("Incorrect SignIn. The app is the wrong one 👎🏽 👎🏽");
      } else {
        pp('🐤🐤🐤🐤 User found on database. Yeah! 🐤 🐤 🐤');
      }
      pp('🐤🐤🐤🐤 about to cache the user on the device ...');
      await Prefs.saveUser(user);
      var countries = await DataAPI.getCountries();
      if (countries.isNotEmpty) {
        pp("🥏 🥏 🥏 First country found in list: ${countries.elementAt(0).name}");
        await Prefs.saveCountry(countries.elementAt(0));
      } else {
        pp('👿 👿 Country not found');
      }
      return user;
    }
  }

  static Future getCountry() async {}
}
