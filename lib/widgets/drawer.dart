/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/service/api/auth/get_user.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/pages/auth/pages/main_page.dart';
import 'package:icrm/features/presentation/pages/drawer/archive/archive.dart';
import 'package:icrm/features/presentation/pages/drawer/companies/pages/companies.dart';
import 'package:icrm/features/presentation/pages/drawer/contacts/contacts.dart';
import 'package:icrm/features/presentation/pages/drawer/create_note/create_note.dart';
import 'package:icrm/features/presentation/pages/drawer/messages/pages/messages.dart';
import 'package:icrm/features/presentation/pages/drawer/notifications/notifications.dart';
import 'package:icrm/features/presentation/pages/drawer/settings/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main_button.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Drawer(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: !UserToken.isDark ? const Color.fromARGB(255, 229, 229, 229) : const Color.fromRGBO(168, 168, 168, 3),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, top: 45),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const LocaleText(
                              'work_space',
                              style: TextStyle(
                                  fontSize: 25, color: AppColors.mainColor),
                            ),
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons_svg/drawer.svg',
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: UserToken.userPhoto,
                                  errorWidget: (context, error, stack) {
                                    return Image.asset('assets/png/no_user.png');
                                  },
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                              radius: 40,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    "${UserToken.name + " " + UserToken.surname}",
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    UserToken.username,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DrawerMainButton(
                        icon: 'assets/icons_svg/archive.svg',
                        text: 'archive',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Archive())),
                      ),
                      DrawerMainButton(
                        icon: 'assets/icons_svg/notification.svg',
                        text: 'notifications',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications())),
                      ),
                      DrawerMainButton(
                        icon: 'assets/icons_svg/contacts.svg',
                        text: 'my_contacts',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Contacts())),
                      ),
                      DrawerMainButton(
                        icon: 'assets/icons_svg/messages.svg',
                        text: 'messages',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Messages())),
                      ),
                      DrawerMainButton(
                        icon: 'assets/icons_svg/companies.svg',
                        text: 'companies',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Companies())),
                      ),
                      DrawerMainButton(
                        icon: 'assets/icons_svg/settings.svg',
                        text: 'settings',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())),
                      ),
                      DrawerMainButton(
                        icon: 'assets/icons_svg/notes.svg',
                        text: 'create_note',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNote(
                          fromNotes: false,
                        ))),
                      ),
                      TextButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                insetPadding: const EdgeInsets.symmetric(),
                                title: Text(
                                  Locales.string(context, 'you_want_exit_profile'),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.mainBold.copyWith(fontSize: 22),
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      MainButton(
                                        color: AppColors.red,
                                        title: 'no',
                                        onTap: () => Navigator.pop(context),
                                        fontSize: 22,
                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                      ),
                                      MainButton(
                                        onTap: () async {
                                          getIt.get<GetUser>().quitProfile().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthMainPage()), (route) => false));
                                        },
                                        color: AppColors.mainColor,
                                        title: 'yes',
                                        fontSize: 22,
                                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                        child: const LocaleText(
                          'quit_profile',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerMainButton extends StatelessWidget {
  const DrawerMainButton(
      {Key? key, required this.icon, required this.text, required this.onTap})
      : super(key: key);

  final String icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Center(
          child: Row(
            children: [
              CircleAvatar(
                child: SvgPicture.asset(icon),
                radius: 19,
                backgroundColor: AppColors.purpleLight,
              ),
              const SizedBox(
                width: 20,
              ),
              LocaleText(
                text,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
