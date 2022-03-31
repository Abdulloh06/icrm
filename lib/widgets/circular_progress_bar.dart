import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class CircularProgressBar extends StatelessWidget {
  const CircularProgressBar({this.fontSize = 12, this.progressColor = AppColors.mainColor, this.percent = 0.8, this.lineWidth = 6, this.radius = 35,  Key? key}) : super(key: key);

  final double radius;
  final double lineWidth;
  final double percent;
  final Color progressColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
    child: CircularPercentIndicator(
      backgroundColor: Color.fromARGB(255, 245, 245, 251),
        radius: radius,
        lineWidth: lineWidth,
        percent: percent / 100,
        center: Text(percent.toInt().toString() + '%', style: UserToken.isDark ? TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ) : TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),),
        progressColor: progressColor,
      ),
    );
  }
}