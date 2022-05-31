/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/notes_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/pages/drawer/create_note/create_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({
    Key? key,
    required this.title,
    required this.date,
    required this.description,
    required this.deleteTap,
    required this.shareTap,
    required this.note,
  }) : super(key: key);

  final String title;
  final String description;
  final String date;
  final NotesModel note;
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
                  height: 20,
                  width: 10,
                  child: PopupMenuButton(
                    onSelected: (index) {
                      if(index == 1) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CreateNote(
                            isSubNote: true,
                            title: note.title,
                            id: note.id,
                            description: note.content,
                          );
                        }));
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          height: 30,
                          value: 1,
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SvgPicture.asset('assets/icons_svg/change.svg', height: 16,),
                              LocaleText('change', style: TextStyle(fontSize: 10),),
                            ],
                          ),
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
                      height: 16,
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

PopupMenuItem popupItem({
  required String icon,
  required String title,
  required VoidCallback onTap,
}) {
  return PopupMenuItem(
    onTap: onTap,
    height: 30,
    padding: const EdgeInsets.all(0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SvgPicture.asset(icon, height: 16,),
        LocaleText(title, style: TextStyle(fontSize: 10),),
      ],
    ),
  );
}

