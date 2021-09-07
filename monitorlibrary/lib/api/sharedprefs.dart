import 'dart:convert';

import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/project.dart';
import 'package:monitorlibrary/data/questionnaire.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions.dart';

class Prefs {
  static void setThemeIndex(int index) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('index', index);
    pp('🔵 🔵 🔵 Prefs: theme index set to: $index 🍎 🍎 ');
  }

  static Future<int> getThemeIndex() async {
    final preferences = await SharedPreferences.getInstance();
    var b = preferences.getInt('index');
    if (b == null) {
      return 0;
    } else {
      pp('🔵 🔵 🔵  theme index retrieved: $b 🍏 🍏 ');
      return b;
    }
  }

  static Future saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map jsonx = user.toJson();
    var jx = json.encode(jsonx);
    prefs.setString('user', jx);
    pp("🌽 🌽 🌽 Prefs.saveUser  SAVED: 🌽 ${user.email}");
    prettyPrint(jsonx, " 🏈 Saved User in Prefs  🏈");
    return null;
  }

  static Future<User?> getUser() async {
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('user');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var user = new User.fromJson(jx);
    pp("🌽 🌽 🌽 Prefs.getUser 🧩  ${user.name} retrieved");
    return user;
  }

  static Future saveCountry(Country country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map jsonx = country.toJson();
    var jx = json.encode(jsonx);
    prefs.setString('country', jx);
    pp("🌽 🌽 🌽 Prefs.saveCountry  SAVED: 🌽 ${country.name}");
    prettyPrint(jsonx, " 🏈 Saved Country in Prefs  🏈");
    return null;
  }

  static Future<Country?> getCountry() async {
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('country');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var cntry = new Country.fromJson(jx);
    pp("🌽 🌽 🌽 Prefs.getCountry 🧩  ${cntry.name} retrieved");
    prettyPrint(cntry.toJson(), " 🏈 Saved Country retrieved from Prefs   🏈");
    return cntry;
  }

  static Future saveQuestionnaire(Questionnaire questionnaire) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map jsonx = questionnaire.toJson();
    pp(jsonx);
    var jx = json.encode(jsonx);
    prefs.setString('questionnaire', jx);
    pp("\n\n🌽 🌽 🌽 Prefs.questionnaire  SAVED: 🌽 ${questionnaire.name}");
    prettyPrint(jsonx, " 🏈 Saved questionnaire in Prefs  🏈");
    pp('\n\n............................................................ 👽 👽 👽 !!');
    return null;
  }

  static Future<Questionnaire?> getQuestionnaire() async {
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('questionnaire');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var cntry = new Questionnaire.fromJson(jx);
    pp("🌽 🌽 🌽 Prefs.questionnaire 🧩  ${cntry.title} retrieved");
    prettyPrint(
        cntry.toJson(), " 🏈 Saved questionnaire retrieved from Prefs   🏈");
    return cntry;
  }

  static Future saveActiveProject(Project project) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map jsonx = project.toJson();
    pp(jsonx);
    var jx = json.encode(jsonx);
    prefs.setString('activeProject', jx);
    pp("\n\n🌽 🌽 🌽 Prefs.project  SAVED: 🌽 ${project.name}");
    prettyPrint(jsonx, " 🏈 Saved project in Prefs  🏈");
    pp('\n\n............................................................ 👽 👽 👽 !!');
    return null;
  }

  static Future<Project?> getActiveProject() async {
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('activeProject');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var cntry = new Project.fromJson(jx);
    pp("🌽 🌽 🌽 Prefs.project 🧩  ${cntry.name} retrieved");
    prettyPrint(cntry.toJson(), " 🏈 Saved project retrieved from Prefs   🏈");
    return cntry;
  }

  static void removeQuestionnaire() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('questionnaire');
    pp("🌽 🌽 🌽 Prefs.removeQuestionnaire 🧩 REMOVED. KAPUT!!");
  }

  static Future saveMinutes(int minutes) async {
    pp("SharedPrefs saving minutes ..........");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("minutes", minutes);

    pp("FCM minutes saved in cache prefs: $minutes");
  }

  static Future<int?> getMinutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var minutes = prefs.getInt("minutes");
    pp("SharedPrefs - FCM minutes from prefs: $minutes");
    return minutes;
  }

  static void savePictureUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("url", url);
    //prefs.commit();
    pp('picture url saved to shared prefs');
  }

  static Future<String?> getPictureUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString("url");
    pp("=================== SharedPrefs url index: $path");
    return path;
  }

  static void savePicturePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("path", path);
    //prefs.commit();
    pp('picture path saved to shared prefs');
  }

  static Future<String?> getPicturePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString("path");
    pp("=================== SharedPrefs path index: $path");
    return path;
  }

  static Future savePageLimit(int pageLimit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("pageLimit", pageLimit);
    pp('SharedPrefs.savePageLimit ######### saved pageLimit: $pageLimit');
    return null;
  }

  static Future<int> getPageLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? pageLimit = prefs.getInt("pageLimit");
    if (pageLimit == null) {
      pageLimit = 10;
    }
    pp("=================== SharedPrefs pageLimit: $pageLimit");
    return pageLimit;
  }

  static Future saveRefreshDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("refresh", date.millisecondsSinceEpoch);
    pp('SharedPrefs.saveRefreshDate ${date.toIso8601String()}');
    return null;
  }

  static Future<DateTime> getRefreshDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? ms = prefs.getInt("refresh");
    if (ms == null) {
      ms = DateTime.now().subtract(Duration(days: 365)).millisecondsSinceEpoch;
    }
    var date = DateTime.fromMillisecondsSinceEpoch(ms);
    pp('SharedPrefs.getRefreshDate ${date.toIso8601String()}');
    return date;
  }
}
