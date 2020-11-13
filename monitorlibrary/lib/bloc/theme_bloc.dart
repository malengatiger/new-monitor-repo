import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitorlibrary/api/sharedprefs.dart';

import '../functions.dart';

final ThemeBloc themeBloc = ThemeBloc();

class ThemeBloc {
  ThemeBloc() {
    pp('✈️✈️ ThemeBloc initializing....');
    initialize();
  }

  final StreamController<int> _themeController = StreamController.broadcast();
  final _rand = Random(DateTime.now().millisecondsSinceEpoch);

  get changeToTheme0 => _themeController.sink.add(0);

  get changeToTheme1 => _themeController.sink.add(1);

  get changeToTheme2 => _themeController.sink.add(2);

  int _themeIndex = 0;

  int get themeIndex => _themeIndex;

  initialize() async {
    _themeIndex = await Prefs.getThemeIndex();
    pp('📌 📌 📌 📌️ ThemeBloc: initialize:: adding index to stream ....theme index: $themeIndex');
    _themeController.sink.add(_themeIndex);
  }

  ThemeData getCurrentTheme() {
    print('✈️✈️ getCurrentTheme: getting and setting current stream ....');
    return ThemeUtil.getTheme(themeIndex: _themeIndex);
  }

  ThemeData getTheme(int index) {
    print('✈️✈️ getTheme: getting and setting current stream ....');
    assert(index != null);
    return ThemeUtil.getTheme(themeIndex: index);
  }

  changeToTheme(int index) {
    print('✈️✈️ changeToTheme: adding index to stream ....');
    _setStream(index);
  }

  changeToRandomTheme() {
    _themeIndex = _rand.nextInt(ThemeUtil.getThemeCount() - 1);
    _setStream(_themeIndex);
  }

  _setStream(int index) {
    pp('✈️✈️ _setStream: setting stream .... to theme index: $index');
    _themeController.sink.add(index);
    Prefs.setThemeIndex(index);
  }

  closeStream() {
    _themeController.close();
  }

  get newThemeStream => _themeController.stream;
}

class ThemeUtil {
  static List<ThemeData> _themes = List();

  static int index;

  static ThemeData getTheme({int themeIndex}) {
    print('🌈 🌈 getting theme with index: 🌈 $index');
    if (_themes.isEmpty) {
      _setThemes();
    }
    if (themeIndex == null) {
      if (index == null) {
        index = 0;
      } else {
        index++;
        if (index == _themes.length) {
          index = 0;
        }
      }
    } else {
      index = themeIndex;
    }
    return _themes.elementAt(index);
  }

  static int getThemeCount() {
    _setThemes();
    return _themes.length;
  }

  static var _rand = Random(DateTime.now().millisecondsSinceEpoch);

  static ThemeData getRandomTheme() {
    if (_themes.isEmpty) _setThemes();
    var index = _rand.nextInt(_themes.length - 1);
    return _themes.elementAt(index);
  }

  static ThemeData getThemeByIndex(int index) {
    if (_themes.isEmpty) _setThemes();
    if (index >= _themes.length || index < 0) index = 0;
    return _themes.elementAt(index);
  }

  static void _setThemes() {
    _themes.clear();

    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.indigo.shade400,
      accentColor: Colors.pink,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(
          color: Colors.indigo.shade300, brightness: Brightness.dark),
      buttonColor: Colors.blue,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.pink,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.pink.shade200),
      buttonColor: Colors.indigo,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.teal,
      accentColor: Colors.purple,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.teal.shade300),
      buttonColor: Colors.pink,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.brown,
      accentColor: Colors.yellow.shade900,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.brown.shade300),
      buttonColor: Colors.blue,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.lime.shade800,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.lime.shade300),
      buttonColor: Colors.brown,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.blue,
      accentColor: Colors.red,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.blue.shade300),
      buttonColor: Colors.blue,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.blueGrey,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.blueGrey.shade300),
      buttonColor: Colors.pink,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.purple,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.purple.shade300),
      buttonColor: Colors.pink,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.amber.shade700,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.amber.shade300),
      buttonColor: Colors.pink,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.deepOrange,
      accentColor: Colors.brown,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.deepOrange.shade300),
      buttonColor: Colors.deepOrange,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.orange,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.orange.shade300),
      buttonColor: Colors.pink,
    ));
    final darkTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF212121),
      accentColor: Colors.white,
      accentIconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.black12,
    );
    _themes.add(darkTheme);

    final lightTheme = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      backgroundColor: const Color(0xFFE5E5E5),
      accentColor: Colors.black,
      accentIconTheme: IconThemeData(color: Colors.white),
      dividerColor: Colors.white54,
    );
    _themes.add(lightTheme);
  }
}
