
/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class AuthMainButton extends StatelessWidget {
  const AuthMainButton({Key? key, required this.title, this.color = AppColors.mainColor, required this.textColor}) : super(key: key);

  final Color color;
  final Color textColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: AppColors.mainColor),
      ),
      child: Center(
        child: LocaleText(
          title,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
