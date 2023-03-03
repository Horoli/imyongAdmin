import 'package:flutter/material.dart';

enum Type { dark, light }

final Map<Type, ThemeData> MAP = {
  Type.dark: DARK,
  Type.light: LIGHT,
};

List<Type> get TYPE_LIST => MAP.keys.toList();
List<ThemeData> get THEMEDATA_LIST => MAP.values.toList();

final ThemeData DARK = ThemeData.dark().copyWith(
  primaryColor: Colors.grey[700],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
    ),
  ),
);

final ThemeData LIGHT = ThemeData.light().copyWith();
