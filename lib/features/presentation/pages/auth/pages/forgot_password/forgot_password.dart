/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../local_widgets/auth_text_field.dart';
import '../../local_widgets/main_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  final _pinController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'I CRM',
                    style: AppTextStyles.primary,
                  ),

                  SizedBox(height: 70),
                  LocaleText('forgot_password', style: AppTextStyles.mainBold.copyWith(fontSize: 22),),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: AuthTextField(
                      helperText: Locales.string(context, 'secret_code_text'),
                      title: Locales.string(context, 'secret_code'),
                      controller: _pinController,
                      validator: (value) => value!.isEmpty ? Locales.string(context, "must_fill_this_line") : value.length < 4 ? Locales.string(context, 'enter_valid_info') : null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    height: 344,
                  ),
                  GestureDetector(
                    onTap: () {
                      if(_formKey.currentState!.validate()){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                      }
                    },
                    child: AuthMainButton(title: 'login', textColor: Colors.white),
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



