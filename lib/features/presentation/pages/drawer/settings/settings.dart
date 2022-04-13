/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/service/shared_preferences_service.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/pages/drawer/settings/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, size: 20),
                        LocaleText('back', style: AppTextStyles.mainBold.copyWith(fontSize: 16,)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.purpleLight,
                    child: SvgPicture.asset('assets/icons_svg/settings.svg'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LocaleText('settings', style: AppTextStyles.mainBold.copyWith(fontSize: 18),),
                  ),
                  SettingsCard(
                    onTap: () {},
                    title: 'change_password',
                    icon: 'assets/icons_svg/change_password.svg',
                  ),
                  SettingsCard(
                    onTap: () {
                      showDialog(context: context, builder: (context) {
                        return SimpleDialog(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                context.changeLocale('en');

                                final _prefs = await SharedPreferences.getInstance();

                                _prefs.setString(PrefsKeys.languageCode, 'en');
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset('assets/png/english.png'),
                                  ),
                                  Text(
                                    "English",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                context.changeLocale('ru');
                                final _prefs = await SharedPreferences.getInstance();
                                _prefs.setString(PrefsKeys.languageCode, 'ru');
                                Navigator.pop(context);
                                },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset('assets/png/russia.png'),
                                  ),
                                  Text(
                                    "Русский",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    },
                    title: 'change_language',
                    icon: 'assets/icons_svg/privacy_policy.svg',
                  ),
                  SettingsCard(
                    onTap: () {},
                    title: 'set_notification',
                    icon: 'assets/icons_svg/archive.svg',
                  ),
                  SettingsCard(
                    onTap: () {},
                    title: 'using_agreements',
                    icon: 'assets/icons_svg/notification_active.svg',
                  ),
                  SettingsCard(
                    onTap: () {},
                    title: 'privacy_policy',
                    icon: 'assets/icons_svg/privacy_policy.svg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
