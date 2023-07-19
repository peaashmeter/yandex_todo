import 'package:flutter/material.dart';

final brightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
        color: Color(0xFFF7F6F2),
        titleTextStyle: TextStyle(color: Colors.black),
        foregroundColor: Colors.black),
    colorScheme: ColorScheme.light(
        background: Color(0xFFF7F6F2),
        surface: Color(0xFFFFFFFF),
        surfaceVariant: Color(0xFFFFFFFF),
        primary: Colors.blue),
    textTheme: const TextTheme(
        labelLarge: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)));
final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.dark(
        background: Color(0xFF161618),
        surface: Color(0xFF252528),
        surfaceVariant: Color(0xFF3C3C3F),
        primary: Colors.blue),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF161618),
        titleTextStyle: TextStyle(color: Colors.black),
        foregroundColor: Colors.black),
    textTheme: const TextTheme(
        labelLarge: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)));
