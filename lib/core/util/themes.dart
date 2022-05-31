/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:flutter/material.dart';

class AppThemes {

  static final dark = ThemeData(
    scaffoldBackgroundColor: AppColors.mainDark,
    backgroundColor: AppColors.mainDark,
    cardTheme: CardTheme(
        color: AppColors.cardColorDark
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.mainColor,
      titleTextStyle: AppTextStyles.mainBold.copyWith(fontSize: 25, color: Colors.white),
      elevation: 1,
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
        size: 20,
      ),
    ),
    primaryIconTheme: const IconThemeData(color: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white),
    brightness: Brightness.dark,
  );

  static final light = ThemeData(
    scaffoldBackgroundColor: AppColors.apColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: AppTextStyles.mainBold.copyWith(fontSize: 25, color: Colors.black),
      elevation: 1,
      actionsIconTheme: const IconThemeData(
        color: Colors.black,
      ),
      iconTheme: const IconThemeData(
          color: Colors.black,
          size: 20
      ),
    ),
    primaryIconTheme: const IconThemeData(color: Colors.black),
    iconTheme: const IconThemeData(color: Colors.black),
  );

}
