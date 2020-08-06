import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/user.dart';

class AppAuth {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> isUserSignedIn() async {
    var authUser = await _auth.currentUser();
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

  static Future createUser(User user, String password) async {
    var fbUser = await _auth
        .createUserWithEmailAndPassword(email: user.email, password: password)
        .catchError((e) {
      print('User create failed');
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
    debugPrint('🔐🔐🔐🔐 Auth signing in $email - $password  🔐🔐🔐🔐');
    var fbUser = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      print(e);
      throw e;
    });
    if (fbUser != null) {
      debugPrint('🔐🔐🔐🔐 Auth finding user by email $email 🔐🔐🔐🔐');
      var user = await DataAPI.findUserByEmail(fbUser.user.email);
      if (user == null) {
        debugPrint('👎🏽 👎🏽 👎🏽 User not registered yet 👿');
        throw Exception("User not found 👿 👿 👿 ");
      }
      if (user.userType != type) {
        debugPrint(
            '👎🏽 👎🏽 👎🏽 There is a fuck up somewhere, user type is WRONG! 👿');
        throw Exception("Incorrect SignIn. The app is the wrong one 👎🏽 👎🏽");
      } else {
        debugPrint('🐤🐤🐤🐤 User found on database. Yeah! 🐤 🐤 🐤');
      }
      debugPrint('🐤🐤🐤🐤 about to cache the user on the device ...');
      await Prefs.saveUser(user);
      var countries = await DataAPI.getCountries();
      if (countries.isNotEmpty) {
        debugPrint(
            "🥏 🥏 🥏 First country found in list: ${countries.elementAt(0).name}");
        await Prefs.saveCountry(countries.elementAt(0));
      } else {
        debugPrint('👿 👿 Country not found');
      }
      return user;
    }
  }

  static Future getCountry() async {}
}
