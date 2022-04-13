import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/main_includes.dart';
import 'package:flutter/material.dart';

class Projects extends StatelessWidget {
  const Projects({
    Key? key,
    required this.title,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
    this.background = Colors.transparent,
    this.textColor = AppColors.greyDark,
    this.splashColor = AppColors.mainColor,
    this.borderWidth = 2,
    this.horizontalPadding = 10,
    this.verticalPadding = 4,
    this.widget = false,
  }) : super(key: key);

  final dynamic title;
  final FontWeight fontWeight;
  final double fontSize;
  final Color textColor;
  final Color background;
  final Color splashColor;
  final double borderWidth;
  final double verticalPadding;
  final double horizontalPadding;
  final bool widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(width: borderWidth, color: AppColors.textFieldColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          // splashColor: splashColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
            decoration: BoxDecoration(
              border: Border.all(width: borderWidth, color: AppColors.textFieldColor),
              borderRadius: BorderRadius.circular(15),
            ),
            child: widget ? title : Text(title, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: textColor),),
          ),
          splashColor: splashColor,
        ),
      ),
    );
  }
}
