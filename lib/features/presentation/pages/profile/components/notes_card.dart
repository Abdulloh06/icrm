/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/widgets/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhoneCallsCard extends StatelessWidget {
  const PhoneCallsCard({
    Key? key,
    required this.people,
    required this.title,
    required this.date,
  }) : super(key: key);

  final List people;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Projects(title: people[0]),
              const SizedBox(width: 6),
              Projects(title: people[1]),
              const Spacer(),
              SvgPicture.asset('assets/icons_svg/menu_icon.svg', color: UserToken.isDark ? AppColors.greyLight : Colors.black, height: 20),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.play_circle_outlined),
                onPressed: () {},
                iconSize: 50,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.mainGrey.copyWith(fontSize: 12),),
                    const SizedBox(height: 10,),
                    LinearProgressIndicator(
                      value: 0.6,
                      color: AppColors.mainColor,
                      backgroundColor: AppColors.greyLight,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class NotesCard extends StatelessWidget {
  const NotesCard({
    Key? key,
    required this.title,
    required this.date,
    required this.description,
    required this.changeTap,
    required this.deleteTap,
    required this.shareTap,
  }) : super(key: key);

  final String title;
  final String description;
  final String date;
  final VoidCallback changeTap;
  final VoidCallback deleteTap;
  final VoidCallback shareTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: AppTextStyles.mainBold.copyWith(fontSize: 12))),
              Theme(
                data: ThemeData(splashColor: Colors.transparent),
                child: SizedBox(
                  height: 13,
                  width: 10,
                  child: PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    itemBuilder: (context) {
                      return [
                        popupItem(
                          icon: 'assets/icons_svg/change.svg',
                          title: 'change',
                          onTap: changeTap,
                        ),
                        popupItem(
                          icon: 'assets/icons_svg/delete.svg',
                          title: 'delete',
                          onTap: deleteTap,
                        ),
                        popupItem(
                          icon: 'assets/icons_svg/share_note.svg',
                          title: 'share',
                          onTap: shareTap,
                        ),
                      ];
                    },
                    padding: const EdgeInsets.all(0),
                    icon: SvgPicture.asset(
                      'assets/icons_svg/menu_icon.svg',
                      color: UserToken.isDark ? AppColors.greyLight : Colors.black,
                      height: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(description,style: AppTextStyles.mainGrey.copyWith(fontSize: 10)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('19:00', style: AppTextStyles.mainGrey.copyWith(fontSize: 10),),
              Text(date, style: AppTextStyles.mainGrey.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

PopupMenuItem popupItem({required String icon, required String title, required VoidCallback onTap}) {
  return PopupMenuItem(
    onTap: onTap,
    height: 20,
    padding: const EdgeInsets.all(0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(icon, height: 12,),
        LocaleText(title, style: TextStyle(fontSize: 8),),
      ],
    ),
  );
}

