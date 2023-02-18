import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor() {
    //Rust orange
    return const Color.fromRGBO(179, 83, 9, 0.8);
  }

  static Color mustardYellow() {
    return const Color.fromRGBO(229, 193, 0, 0.8);
  }
}

class AppTextStyle {
  static TextStyle titleText() {
    //Rust orange
    return TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400, color: AppColors.primaryColor());
  }
}
