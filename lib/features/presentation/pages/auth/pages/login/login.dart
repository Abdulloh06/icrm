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
import 'package:icrm/features/presentation/pages/auth/pages/forgot_password/forgot_password.dart';
import 'package:icrm/features/presentation/pages/auth/pages/local_widgets/auth_text_field.dart';
import 'package:icrm/features/presentation/pages/auth/pages/local_widgets/main_button.dart';
import 'package:icrm/features/presentation/pages/widgets/change_user_profile.dart';
import 'package:icrm/widgets/social_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/service/shared_preferences_service.dart';
import '../../../main/main_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _pinCodeController = TextEditingController();
  bool isObscure = true;
  PhoneNumber phoneNumber = PhoneNumber(phoneNumber: '');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      body: BlocConsumer<AuthBloc, AuthStates>(
        listener: (context, state) {
          print(state);
          if(state is AuthSignInSuccessSate) {
            if(UserToken.name == '' || UserToken.surname == ''){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeUserProfile()));
            }else {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
              SharedPreferencesService.instance.then((value) => value.setAuth(true));
            }
          } else if(state is AuthErrorState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(20),
                backgroundColor: AppColors.mainColor,
                content: LocaleText(state.error, style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
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
          } else {
            return SafeArea(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'icrm CRM',
                          style: AppTextStyles.primary,
                        ),
                        SizedBox(height: 70),
                        LocaleText(
                          'welcome',
                          style: AppTextStyles.mainBold.copyWith(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        LocaleText(
                          'login_text',
                          style: AppTextStyles.mainGrey,
                        ),
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                context.read<AuthBloc>().add(AuthSignInWithPhoneEvent());
                              },
                              child: LocaleText('phone', style: AppTextStyles.mainGrey),
                            ),
                            Text("  |  ", style: AppTextStyles.mainGrey),
                            InkWell(
                              onTap: () {
                                context.read<AuthBloc>().add(AuthSignInWithEmailEvent());
                              },
                              child: LocaleText('email', style: AppTextStyles.mainGrey),
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<AuthBloc, AuthStates>(
                                builder: (context, state) {
                                  if(state is AuthSignInWithEmailState) {
                                    return AuthTextField(
                                      title: '',
                                      controller: _emailController,
                                      validator: (value) => value!.isEmpty ? Locales.string(context, 'must_fill_this_line') : !value.contains('@') ? Locales.string(context, 'enter_valid_info') : null,
                                      keyboardType: TextInputType.emailAddress,
                                      hint: Locales.string(context, 'email'),
                                    );
                                  }else {
                                    return InternationalPhoneNumberInput(
                                      validator: (value) => value!.isEmpty
                                          ? Locales.string(
                                          context, "must_fill_this_line")
                                          : value.length < 7
                                          ? Locales.string(
                                          context, "enter_valid_info")
                                          : null,
                                      onInputChanged: (number) => phoneNumber = number,
                                      countries: [
                                        'RU', 'UZ', 'US', 'KG', 'AG'
                                      ],
                                      cursorColor: AppColors.mainColor,
                                      keyboardType: TextInputType.number,
                                      errorMessage: Locales.string(context, 'enter_valid_info'),
                                      inputDecoration: InputDecoration(
                                        hintText: Locales.string(context, 'phone'),
                                        enabledBorder:
                                        const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: AppColors.greyDark,
                                          ),
                                        ),
                                        focusedBorder:
                                        const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                        errorBorder:
                                        const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: AppColors.red),
                                        ),
                                        focusedErrorBorder:
                                        const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              AuthTextField(
                                isObscure: isObscure,
                                title: Locales.string(context, 'pin_code'),
                                onTap: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                suffixIcon: 'assets/icons_svg/eye.svg',
                                controller: _pinCodeController,
                                margin: 10,
                                hint: ' *  *  *  * ',
                                validator: (value) => value!.isEmpty ? Locales.string(context, "must_fill_this_line") : value.length < 4
                                    ? Locales.string(
                                    context, "enter_valid_info")
                                    : null,
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 42),
                        SocialBoard(
                          facebookOnTap: () => context.read<AuthBloc>().add(AuthFacebookSignInEvent()),
                          googleOnTap: () => context.read<AuthBloc>().add(AuthGoogleSignInEvent()),
                          yandexOnTap: () => context.read<AuthBloc>().add(AuthYandexSignInEvent()),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthSignInEvent(
                                username: _emailController.text != '' ? _emailController.text : phoneNumber.phoneNumber!.split('+').join(),
                                pinCode: _pinCodeController.text,
                              ));
                            }
                          },
                          child: AuthMainButton(title: 'login', textColor: Colors.white),
                        ),
                        SizedBox(height: 30,),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ForgotPassword())),
                            child: Text(
                              Locales.string(context, 'forgot_password') + "?",
                              style: AppTextStyles.primary.copyWith(fontSize: 14),
                            ),
                          ),
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
