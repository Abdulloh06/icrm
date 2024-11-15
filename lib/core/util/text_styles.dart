/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {

  static TextStyle mainBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle primary = const TextStyle(
    color: AppColors.mainColor,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static TextStyle apppText = const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static TextStyle aappText = const TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static TextStyle aappText2 = const TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle proText = const TextStyle(
    color: AppColors.pressColor,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static TextStyle apText = const TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle mainGrey = const TextStyle(
    color: AppColors.greyDark,
    fontSize: 16,
  );

  static TextStyle headerTask = const TextStyle(
    fontSize: 26,
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w900,
  );

  static TextStyle headerLeads = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );


  static TextStyle headerTask3 = const TextStyle(
    fontSize: 16,
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w700,
  );
  static TextStyle projectsTextGrey = const TextStyle(
    color: AppColors.scrollProjectsTextGrey,
    fontSize: 14,
  );

  static TextStyle statusHighText = const TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 255, 97, 87),
  );

  static TextStyle priorityCompletedText = const TextStyle(
    fontSize: 10,
    color: Color.fromARGB(255, 97, 200, 119),
  );

  static TextStyle descriptionGrey = const TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 187, 187, 187),
  );

  static TextStyle mainTextFont = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );



}