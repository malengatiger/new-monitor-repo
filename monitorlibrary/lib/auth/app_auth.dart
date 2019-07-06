import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitorlibrary/api/data_api.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';
import 'package:monitorlibrary/data/user.dart';
class AppAuth {

  static FirebaseAuth _auth  = FirebaseAuth.instance;

  static Future<bool> isUserSignedIn() async {
    var user = await _auth.currentUser();
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }
   static Future createUser(User user, String password)  async {
    var fbUser = await _auth.createUserWithEmailAndPassword(email: user.email, password: password)
    .catchError((e) {
      print('User create failed');
    });
    if (fbUser != null) {
      var mUser =  await DataAPI.addUser(user);
      await Prefs.saveUser(mUser);
    }
   }
   static Future signIn({String email, String password})  async {
     var fbUser = await _auth.signInWithEmailAndPassword(email: email, password: password)
     .catchError((e) {
       print(e);
       throw e;
     });
     if (fbUser != null) {
       var user = await DataAPI.getUserByUid(fbUser.uid);
       await Prefs.saveUser(user);
     }
   }
}