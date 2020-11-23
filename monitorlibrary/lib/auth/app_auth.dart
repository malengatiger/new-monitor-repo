import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/user.dart' as mon;

import '../functions.dart';

class AppAuth {
  static FirebaseAuth _auth;

  static Future isUserSignedIn() async {
    pp('🥦 🥦  😎😎😎😎 AppAuth: isUserSignedIn :: 😎😎😎 about to initialize Firebase; 😎');
    var app = await Firebase.initializeApp();
    pp('😎😎😎😎 AppAuth: isUserSignedIn :: 😎😎😎 Firebase has been initialized; '
        '😎 or not? 🍀🍀 app: ${app.options.databaseURL}');
    _auth = FirebaseAuth.instance;
    var authUser = _auth.currentUser;
    if (authUser == null) {
      pp('👿👿👿 user is not signed in yet ....');
      return null;
    }
    var user = await Prefs.getUser();
    if (authUser == null) {
      return null;
    } else {
      if (user != null) {
        pp('🦠🦠🦠 user is signed in. 🦠 .... ${user.toJson()}');
        return user;
      } else {
        return null;
      }
    }
  }

  static Future<mon.User> createUser(mon.User user, String password) async {
    pp('AppAuth: 💜 💜 createUser:, auth record to be created ... ${user.toJson()}');
    var fbUser = await _auth
        .createUserWithEmailAndPassword(email: user.email, password: password)
        .catchError((e) {
      pp('👿👿👿 User create failed : $e');
      throw e;
    });
    mon.User mUser;
    if (fbUser != null) {
      pp('AppAuth:  💜 💜 createUser, auth record created, adding to database ...');
      user.userId = fbUser.user.uid;
      mUser = await DataAPI.addUser(user);
      await Prefs.saveUser(mUser);
      var countries = await DataAPI.getCountries();
      if (countries.isNotEmpty) {
        await Prefs.saveCountry(countries.elementAt(0));
      }
    } else {
      throw Exception('👿 👿 👿 Firebase auth record addition failed');
    }
    if (mUser != null) {
      pp('AppAuth:  💜 💜 💜 💜 createUser, after adding to Mongo database ....... ${mUser.toJson()}');
    } else {
      pp('AppAuth:  👿👿👿 createUser: this is Houston path, Mongo api call failed ');
    }
    return mUser;
  }

  static Future<String> getAuthToken() async {
    var token = await _auth.currentUser.getIdToken();
    pp(' 🔐 🔐 🔐 🔐 Firebase auth token: $token  🔐 🔐 🔐 🔐');
    return token;
  }

  static Future signIn(String email, String password, String type) async {
    pp('🔐 🔐 🔐 🔐 Auth signing in $email 🌸 $password  🔐 🔐 🔐 🔐');

    var fbUser = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      pp('👿👿👿 Firebase sign in failed, 👿 message below');
      pp(e);
      throw e;
    });
    if (fbUser != null) {
      pp('🔐 🔐 🔐 🔐 Auth finding user by email $email 🔐 🔐 🔐 🔐');
      var user = await DataAPI.findUserByEmail(fbUser.user.email);
      if (user == null) {
        pp('👎🏽 👎🏽 👎🏽 User not registered yet 👿');
        throw Exception("User not found on Firebase auth 👿 👿 👿 ");
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
