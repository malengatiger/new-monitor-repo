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
  static List<ThemeData> _themes = [];

  static int index = 0;

  static ThemeData getTheme({required int themeIndex}) {
    print('🌈 🌈 getting theme with index: 🌈 $index');
    if (_themes.isEmpty) {
      _setThemes();
    }

    index++;
    if (index == _themes.length) {
      index = 0;
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
      primaryColor: Colors.indigo.shade500,
      accentColor: Colors.pink,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(
          color: Colors.indigo.shade300, brightness: Brightness.dark),
      buttonColor: Colors.blue,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.pink.shade300,
      accentColor: Colors.teal.shade400,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(elevation: 8, color: Colors.pink.shade300),
      buttonColor: Colors.indigo,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.teal.shade300,
      accentColor: Colors.purple.shade300,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.teal.shade300),
      buttonColor: Colors.pink.shade400,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.brown.shade300,
      accentColor: Colors.yellow.shade300,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.brown.shade300),
      buttonColor: Colors.brown,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.amber.shade800,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.amber.shade700),
      buttonColor: Colors.brown,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.blue.shade400,
      accentColor: Colors.red.shade300,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.blue.shade400),
      buttonColor: Colors.blue,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.blueGrey.shade400,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.blueGrey.shade400),
      buttonColor: Colors.pink,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.purple.shade500,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.purple.shade300),
      buttonColor: Colors.pink,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.deepPurple.shade300,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.deepPurple.shade300),
      buttonColor: Colors.pink,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.deepOrange.shade300,
      accentColor: Colors.brown,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.deepOrange.shade300),
      buttonColor: Colors.deepOrange.shade400,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.orange.shade400,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.orange.shade300),
      buttonColor: Colors.orange,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.red.shade300,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.red.shade300),
      buttonColor: Colors.red.shade400,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.green.shade300,
      accentColor: Colors.yellow,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.green.shade300),
      buttonColor: Colors.green.shade400,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.amber.shade700,
      accentColor: Colors.red,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.amber.shade700),
      buttonColor: Colors.amber.shade900,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.grey.shade600,
      accentColor: Colors.yellow,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.grey.shade600),
      buttonColor: Colors.pink.shade400,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.lime.shade700,
      accentColor: Colors.teal,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.lime.shade700),
      buttonColor: Colors.lime.shade900,
    ));
    _themes.add(ThemeData(
      fontFamily: GoogleFonts.raleway().fontFamily,
      primaryColor: Colors.indigo.shade300,
      accentColor: Colors.green,
      cardColor: Colors.white,
      backgroundColor: Colors.brown.shade100,
      appBarTheme: AppBarTheme(color: Colors.indigo.shade300),
      buttonColor: Colors.indigo.shade400,
    ));
    //
    // final darkTheme = ThemeData(
    //   primarySwatch: Colors.grey,
    //   primaryColor: Colors.black,
    //   brightness: Brightness.dark,
    //   backgroundColor: const Color(0xFF212121),
    //   accentColor: Colors.white,
    //   accentIconTheme: IconThemeData(color: Colors.black),
    //   dividerColor: Colors.black12,
    // );
    // _themes.add(darkTheme);
    //
    // final lightTheme = ThemeData(
    //   primarySwatch: Colors.grey,
    //   primaryColor: Colors.white,
    //   brightness: Brightness.light,
    //   backgroundColor: const Color(0xFFE5E5E5),
    //   accentColor: Colors.black,
    //   accentIconTheme: IconThemeData(color: Colors.white),
    //   dividerColor: Colors.white54,
    // );
    // _themes.add(lightTheme);
  }
}
