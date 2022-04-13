/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainCategory extends StatelessWidget {
  const MainCategory({
    Key? key,
    required this.title,
    required this.length,
    required this.icon,
    required this.borderRadius,
    required this.color,
  }) : super(key: key);

  final String title;
  final int length;
  final String icon;
  final Color color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(length.toString(), style: AppTextStyles.mainBold.copyWith(fontSize: 32, color: UserToken.isDark ? Colors.black : Colors.white),),
                SvgPicture.asset(icon),
              ],
            ),
            const Spacer(),
            LocaleText(
              title,
              style: AppTextStyles.mainBold.copyWith(color: UserToken.isDark ? Colors.black : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
