import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Color(0xffdad7cd),
      primary: Color(0xffa3b18a),
      secondary: Color(0xff588157),
      tertiary: Color(0xff3a5a40),
      scrim: Color.fromARGB(255, 232, 228, 211),
      inversePrimary: Color(0xff344e41),
      shadow: Colors.grey.withOpacity(0.5),
      onError: Colors.black,
      onSecondary: Color(0xff588157),
      surface: Color.fromARGB(255, 232, 228, 211),
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        background: Color(0xff344e41),
        primary: Color(0xff588157),
        secondary: Color(0xff3a5a40),
        tertiary: Color(0xffdad7cd),
        scrim: Color.fromARGB(255, 48, 68, 58),
        inversePrimary: Color(0xffa3b18a),
        shadow: Color.fromARGB(255, 32, 47, 40).withOpacity(0.5),
        onError: Colors.white,
        onSecondary: Color(0xffa3b18a),
        surface: Color(0xffa3b18a)));
