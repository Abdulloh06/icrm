/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/pages/drawer/settings/components/language_dialog.dart';
import 'package:icrm/features/presentation/pages/drawer/settings/components/privacy_policy.dart';
import 'package:icrm/features/presentation/pages/drawer/settings/components/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icrm/features/presentation/pages/drawer/settings/components/using_agreements.dart';
import 'package:icrm/features/presentation/pages/drawer/settings/pages/change_password.dart';

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
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                    },
                    title: 'change_password',
                    icon: 'assets/icons_svg/change_password.svg',
                  ),
                  SettingsCard(
                    onTap: () {
                      showDialog(context: context, builder: (context) {
                        return LanguageDialog();
                      });
                    },
                    title: 'change_language',
                    icon: 'assets/icons_svg/privacy_policy.svg',
                  ),
                  SettingsCard(
                    onTap: () {
                      showDialog(context: context, builder: (context) {
                        return UsingAgreements();
                      });
                    },
                    title: 'using_agreements',
                    icon: 'assets/icons_svg/notification_active.svg',
                  ),
                  SettingsCard(
                    onTap: () {
                      showDialog(context: context, builder: (context) {
                        return PrivacyPolicy();
                      });
                    },
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
