/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:icrm/features/presentation/pages/auth/pages/local_widgets/auth_text_field.dart';
import 'package:icrm/features/presentation/pages/auth/pages/local_widgets/main_button.dart';
import 'package:icrm/features/presentation/pages/auth/pages/local_widgets/main_button_back.dart';
import 'package:icrm/features/presentation/pages/widgets/change_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

class SignUpPage3 extends StatefulWidget {
  SignUpPage3({Key? key, required this.via}) : super(key: key);

  final String via;

  @override
  State<SignUpPage3> createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool isObscure1 = true;
  bool isObscure2 = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      body: BlocConsumer<AuthBloc, AuthStates>(
        listener: (context, state) {
          if(state is AuthSignUpSuccessConfirm) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeUserProfile()));
          }
          if(state is AuthErrorState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                margin: const EdgeInsets.all(15),
                backgroundColor: AppColors.redLight,
                behavior: SnackBarBehavior.floating,
                content: LocaleText(state.error, style: TextStyle(color: AppColors.red)),
              ),
            );
          }
        },
        builder: (context, state) {
          if(state is AuthLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          }else {
            return SafeArea(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AuthButtonBack(),
                            Text(
                              'icrm CRM',
                              style: AppTextStyles.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                        LocaleText(
                          'last_step',
                          style: AppTextStyles.mainBold.copyWith(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        LocaleText(
                          'last_step_text',
                          style: AppTextStyles.mainGrey,
                        ),
                        const SizedBox(height: 35),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AuthTextField(
                                title: Locales.string(context, 'pin_code'),
                                controller: _pinController,
                                margin: 10,
                                onTap: () {
                                  setState(() {
                                    isObscure1 = !isObscure1;
                                  });
                                },
                                isObscure: isObscure1,
                                suffixIcon: 'assets/icons_svg/eye.svg',
                                validator: (value) =>
                                value!.isEmpty ? Locales.string(context, "must_fill_this_line") : value != _confirmPinController.text ? Locales.string(context, "pin_codes_do_not_match") : null,
                                keyboardType: TextInputType.text,
                              ),
                              AuthTextField(
                                onTap: () {
                                  setState(() {
                                    isObscure2 = !isObscure2;
                                  });
                                },
                                title: Locales.string(context, 'confirm'),
                                controller: _confirmPinController,
                                suffixIcon: 'assets/icons_svg/eye.svg',
                                isObscure: isObscure2,
                                margin: 10,
                                validator: (value) =>
                                value!.isEmpty ? Locales.string(context, "must_fill_this_line") : value != _pinController.text ? Locales.string(context, "pin_codes_do_not_match") : null,
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 190,
                        ),
                        GestureDetector(
                          onTap: () {
                            if(_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthSignUpConfirmation(via: widget.via, password: _pinController.text, confirmPassword: _confirmPinController.text));
                            }
                          },
                          child: AuthMainButton(title: 'next', textColor: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

