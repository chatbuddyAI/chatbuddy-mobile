import 'package:chat_buddy/common/utils/coloors.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Coloors.mustardYellow,
      onPrimary: Coloors.mustardYellow,
      secondary: Coloors.mustardYellow,
      onSecondary: Coloors.black,
      error: Coloors.red,
      onError: Coloors.red,
      background: Coloors.backgroundDark,
      onBackground: Coloors.backgroundDark,
      surface: Coloors.black,
      onSurface: Coloors.white,
      surfaceVariant: Coloors.mustardYellowLight,
      onSurfaceVariant: Coloors.white,
    ),
    primaryColor: Coloors.mustardYellow,
    scaffoldBackgroundColor: Coloors.backgroundDark,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Coloors.backgroundDark,
      foregroundColor: Coloors.white,
    ),
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Coloors.mustardYellow),
      ),
      indicatorColor: Coloors.rustOrange,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      splashFactory: NoSplash.splashFactory,
      unselectedLabelColor: Coloors.inactiveTextGrey,
      labelColor: Coloors.mustardYellow,
    ),
    // inputDecorationTheme: InputDecorationTheme(
    //   focusedBorder: OutlineInputBorder(
    //     borderSide: const BorderSide(
    //       color: Coloors.rustOrange,
    //       width: 1.0,
    //     ),
    //     borderRadius: BorderRadius.circular(15.0),
    //   ),
    //   focusColor: Coloors.rustOrange,
    //   hoverColor: Coloors.rustOrange,
    // ),
  );
}
