/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialBoard extends StatelessWidget {
  const SocialBoard({
    Key? key,
    required this.facebookOnTap,
    required this.googleOnTap,
    required this.yandexOnTap,
    required this.appleOnTap,
  }) : super(key: key);

  final VoidCallback facebookOnTap;
  final VoidCallback googleOnTap;
  final VoidCallback yandexOnTap;
  final VoidCallback appleOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        LocaleText(
          'login_with',
          style: AppTextStyles.mainGrey,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: facebookOnTap,
              child: SvgPicture.asset('assets/icons_svg/facebook.svg'),
            ),
            GestureDetector(
              onTap: googleOnTap,
              child: SvgPicture.asset('assets/icons_svg/google.svg'),
            ),
            GestureDetector(
              onTap: yandexOnTap,
              child: SvgPicture.asset('assets/icons_svg/yandex.svg'),
            ),
          ],
        ),
      ],
    );
  }
}
