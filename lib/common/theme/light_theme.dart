import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Coloors.rustOrange,
      onPrimary: Coloors.mustardYellow,
      secondary: Coloors.rustOrange,
      onSecondary: Coloors.white,
      error: Coloors.red,
      onError: Coloors.red,
      background: Coloors.greyLight,
      onBackground: Colors.grey,
      surface: Coloors.greyLight,
      onSurface: Coloors.black,
      surfaceVariant: Coloors.mustardYellowLight,
      onSurfaceVariant: Coloors.rustOrange,
    ),
    primaryColor: Coloors.rustOrange,
    scaffoldBackgroundColor: Coloors.white,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Coloors.white,
      foregroundColor: Coloors.black,
    ),
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Coloors.rustOrange),
      ),
      indicatorColor: Coloors.rustOrange,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      splashFactory: NoSplash.splashFactory,
      unselectedLabelColor: Coloors.inactiveTextGrey,
      labelColor: Coloors.rustOrange,
    ),
  );
}
