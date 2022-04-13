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
  }) : super(key: key);

  final VoidCallback facebookOnTap;
  final VoidCallback googleOnTap;
  final VoidCallback yandexOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocaleText(
          'login_with',
          style: AppTextStyles.mainGrey,
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: facebookOnTap,
              child: SvgPicture.asset('assets/icons_svg/facebook.svg'),
            ),
            const SizedBox(width: 50,),
            GestureDetector(
              onTap: googleOnTap,
              child: SvgPicture.asset('assets/icons_svg/google.svg'),
            ),
            const SizedBox(width: 50,),
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
