import 'package:avlo/core/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Status extends StatelessWidget {
  const Status({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      alignment: Alignment.center,
      height: 24,
      width: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: text == 'new'
              ? AppColors.mainColor
              : text == 'in_progress'
                  ? AppColors.mainYellow
                  : text == 'completed'
                      ? AppColors.green
                      : AppColors.mainRed),
      child: LocaleText(
        text,
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }
}
