import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.color,
    required this.title,
    required this.onTap,
    this.borderRadius = 10,
    this.fontSize = 14,
    this.padding = const EdgeInsets.all(15),
  }) : super(key: key);

  final Color color;
  final String title;
  final VoidCallback onTap;
  final double borderRadius;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
        ),
        child: Center(
          child: LocaleText(title, style: TextStyle(color: Colors.white, fontSize: fontSize),),
        ),
      ),
    );
  }
}
