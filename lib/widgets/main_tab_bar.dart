import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
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
  }) : super(key: key);



  final List<Widget> tabs;
  final List<BoxShadow> shadow;
  final bool isScrollable;
  final double fontSize;
  final FontWeight fontWeight;


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
          isScrollable: isScrollable,
          labelStyle: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          unselectedLabelColor: AppColors.mainColor,
          automaticIndicatorColorAdjustment: false,
          indicator: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(8),
          ),
          tabs: tabs,
        )
    );
  }
}
