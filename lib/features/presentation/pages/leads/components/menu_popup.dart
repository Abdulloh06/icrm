/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';


class MenuPopup extends StatelessWidget {
  const MenuPopup({
    Key? key,
    required this.icon,
    required this.deleteTap,
    required this.shareTap,
  }) : super(key: key);

  final VoidCallback deleteTap;
  final VoidCallback shareTap;
  final SvgPicture icon;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
      ),
      child: SizedBox(
        height: 20,
        width: 20,
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemBuilder: (context) {
            return [
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
          icon: icon,
        ),
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