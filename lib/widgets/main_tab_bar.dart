/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:flutter/material.dart';

class MainTabBar extends StatelessWidget {
  const MainTabBar({
    Key? key,
    required this.tabs,
    this.isScrollable = false,
    this.shadow = const [
      BoxShadow(),
    ],
    this.fontWeight = FontWeight.bold,
    this.fontSize = 12,
    this.controller,
    this.onTap,
    this.labelPadding = const EdgeInsets.all(0),
  }) : super(key: key);



  final List<Widget> tabs;
  final List<BoxShadow> shadow;
  final bool isScrollable;
  final double fontSize;
  final FontWeight fontWeight;
  final TabController? controller;
  final Function(int index)? onTap;
  final EdgeInsets labelPadding;


  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          color:
          UserToken.isDark ? AppColors.cardColorDark : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: shadow,
        ),
        child: TabBar(
          onTap: onTap,
          controller: controller,
          isScrollable: isScrollable,
          labelPadding: labelPadding,
          labelStyle: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          unselectedLabelColor: AppColors.mainColor,
          automaticIndicatorColorAdjustment: false,
          padding: const EdgeInsets.all(5),
          indicator: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(8),
          ),
          tabs: tabs
        ),
    );
  }
}
