/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Priority extends StatelessWidget {
  const Priority({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: LocaleText(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}
