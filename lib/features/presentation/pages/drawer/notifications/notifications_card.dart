/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 87,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 0.1,
            blurRadius: 0.1,
          ),
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 15,
            height: 87,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 12, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Создан новый лид', style: AppTextStyles.mainBold,),
                      const SizedBox(height: 10),
                      Text('Разработка UI/UX ', style: AppTextStyles.mainGrey.copyWith(fontSize: 12),),
                      const SizedBox(height: 10,),
                      Text('08 август 2021    19:03', style: AppTextStyles.mainGrey.copyWith(fontSize: 11),)
                    ],
                  ),
                  SvgPicture.asset('assets/icons_svg/menu_icon.svg', height: 13, color: UserToken.isDark ? AppColors.greyLight : Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
