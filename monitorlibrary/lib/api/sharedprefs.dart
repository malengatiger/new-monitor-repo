import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:monitorlibrary/data/country.dart';
import 'package:monitorlibrary/data/user.dart';
import 'package:monitorlibrary/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map jsonx = user.toJson();
    var jx = json.encode(jsonx);
    prefs.setString('user', jx);
    debugPrint(
        "🌽 🌽 🌽 Prefs.saveUser  SAVED: 🌽 ${user.email}");
    prettyPrint(jsonx, " 🏈 Saved User in Prefs  🏈");
    return null;
  }

  static Future<User> getUser() async {
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('user');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var user = new User.fromJson(jx);
    debugPrint(
        "🌽 🌽 🌽 Prefs.getUser 🧩  ${user.email} retrieved");
    prettyPrint(user.toJson(), " 🏈 Saved User retrieved from Prefs   🏈");
    return user;
  }
  static Future saveCountry(Country country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map jsonx = country.toJson();
    var jx = json.encode(jsonx);
    prefs.setString('country', jx);
    debugPrint(
        "🌽 🌽 🌽 Prefs.saveCountry  SAVED: 🌽 ${country.name}");
    prettyPrint(jsonx, " 🏈 Saved Country in Prefs  🏈");
    return null;
  }

  static Future<Country> getCountry() async {
    var prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('country');
    if (string == null) {
      return null;
    }
    var jx = json.decode(string);
    var cntry = new Country.fromJson(jx);
    debugPrint(
        "🌽 🌽 🌽 Prefs.getCountry 🧩  ${cntry.name} retrieved");
    prettyPrint(cntry.toJson(), " 🏈 Saved Country retrieved from Prefs   🏈");
    return cntry;
  }

  static Future saveMinutes(int minutes) async {
    debugPrint("SharedPrefs saving minutes ..........");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("minutes", minutes);

    debugPrint("FCM minutes saved in cache prefs: $minutes");
  }

  static Future<int> getMinutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var minutes = prefs.getInt("minutes");
    debugPrint("SharedPrefs - FCM minutes from prefs: $minutes");
    return minutes;
  }

  static void saveThemeIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("themeIndex", index);
    //prefs.commit();
  }

  static Future<int> getThemeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt("themeIndex");
    debugPrint("=================== SharedPrefs theme index: $index");
    return index;
  }

  static void savePictureUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("url", url);
    //prefs.commit();
    debugPrint('picture url saved to shared prefs');
  }

  static Future<String> getPictureUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = prefs.getString("url");
    debugPrint("=================== SharedPrefs url index: $path");
    return path;
  }

  static void savePicturePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("path", path);
    //prefs.commit();
    debugPrint('picture path saved to shared prefs');
  }

  static Future<String> getPicturePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = prefs.getString("path");
    debugPrint("=================== SharedPrefs path index: $path");
    return path;
  }

  static Future savePageLimit(int pageLimit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("pageLimit", pageLimit);
    debugPrint('SharedPrefs.savePageLimit ######### saved pageLimit: $pageLimit');
    return null;
  }

  static Future<int> getPageLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int pageLimit = prefs.getInt("pageLimit");
    if (pageLimit == null) {
      pageLimit = 10;
    }
    debugPrint("=================== SharedPrefs pageLimit: $pageLimit");
    return pageLimit;
  }

  static Future saveRefreshDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("refresh", date.millisecondsSinceEpoch);
    debugPrint('SharedPrefs.saveRefreshDate ${date.toIso8601String()}');
    return null;
  }

  static Future<DateTime> getRefreshDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int ms = prefs.getInt("refresh");
    if (ms == null) {
      ms = DateTime.now().subtract(Duration(days: 365)).millisecondsSinceEpoch;
    }
    var date = DateTime.fromMillisecondsSinceEpoch(ms);
    debugPrint('SharedPrefs.getRefreshDate ${date.toIso8601String()}');
    return date;
  }
}
