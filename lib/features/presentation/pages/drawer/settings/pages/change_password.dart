/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/service/api/auth/login_service.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/pages/widgets/one_button.dart';
import 'package:flutter/material.dart';
import 'package:icrm/features/presentation/pages/leads/components/leads_page_includes.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:icrm/widgets/custom_text_field.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({Key? key}) : super(key: key);

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'change_password',
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    isFilled: true,
                    color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                    hint: 'current_password',
                    validator: (value) =>
                    value!.isEmpty ? Locales.string(context, 'must_fill_this_line')
                        : value.length >= 6 ? null
                        : Locales.string(context, 'weak_password'),
                    controller: _oldPasswordController,
                    onChanged: (value) {},
                  ),
                  const Divider(
                    thickness: 2,
                    height: 40,
                  ),
                  CustomTextField(
                    isFilled: true,
                    color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                    hint: 'new_password',
                    validator: (value) =>
                    value!.isEmpty ? Locales.string(context, 'must_fill_this_line')
                        : value.length < 6
                        ? Locales.string(context, 'weak_password') :
                    value != _confirmPasswordController.text ?
                    Locales.string(context, 'passwords_do_not_match')
                        :  null,
                    controller: _newPasswordController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    isFilled: true,
                    color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                    hint: 'confirm_password',
                    validator: (value) =>
                    value!.isEmpty ? Locales.string(context, 'must_fill_this_line')
                        : value.length < 6
                        ? Locales.string(context, 'weak_password') :
                        value != _newPasswordController.text ?
                            Locales.string(context, 'passwords_do_not_match')
                        :  null,
                    controller: _confirmPasswordController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 40),
                  OneButtonWidget(
                    press: () async {
                      if(_formKey.currentState!.validate()) {
                        try {
                          bool result = await getIt.get<LoginService>().changePassword(
                            oldPassword: _oldPasswordController.text,
                            newPassword: _newPasswordController.text,
                          );

                          if(result) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.all(20),
                                backgroundColor: AppColors.mainColor,
                                content: LocaleText("password_changed", style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
                              ),
                            );
                          }
                        } catch(e) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.all(20),
                              backgroundColor: AppColors.mainColor,
                              content: LocaleText("something_went_wrong", style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
