/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/service/shared_preferences_service.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_event.dart';
import 'package:icrm/features/presentation/pages/auth/pages/sign_up/sign_up_page2.dart';
import 'package:icrm/features/presentation/pages/main/main_page.dart';
import 'package:icrm/features/presentation/pages/widgets/change_user_profile.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/social_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../../core/repository/api_repository.dart';
import '../../local_widgets/auth_text_field.dart';
import '../../local_widgets/main_button.dart';
import '../../local_widgets/main_button_back.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  PhoneNumber phoneNumber = PhoneNumber(
    isoCode: "UZ"
  );

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      body: BlocConsumer<AuthBloc, AuthStates>(
        listener: (context, state) {
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
          if(state is AuthSignUpSuccessOne) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage2(via: state.via)));
          } else if(state is AuthSignUpFromSocialSuccess) {
            if(UserToken.name != '' || UserToken.surname != '') {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
              SharedPreferencesService.instance.then((value) => value.setAuth(true));
            } else {
              context.read<ProfileBloc>().add(ProfileInitEvent());
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeUserProfile()));
            }
          }
        },
        builder: (context, state) {
          if(state is AuthLoadingState) {
            return Loading();
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
                              'I CRM',
                              style: AppTextStyles.primary,
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                        LocaleText(
                          'sign_up',
                          style: AppTextStyles.mainBold.copyWith(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        LocaleText(
                          'sign_up_text',
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
                          child: BlocBuilder<AuthBloc, AuthStates>(
                            builder: (context, state) {
                              if(state is AuthSignInWithEmailState) {
                                return AuthTextField(
                                  title: '',
                                  controller: _emailController,
                                  validator: (value) => value!.isEmpty ? Locales.string(context, 'must_fill_this_line') : !value.contains('@') ? Locales.string(context, 'enter_valid_info') : null,
                                  keyboardType: TextInputType.emailAddress,
                                  hint: Locales.string(context, 'email'),
                                );
                              } else {
                                return InternationalPhoneNumberInput(
                                  validator: (value) => value!.isEmpty ? Locales.string(context, "must_fill_this_line") : value.length < 7 ? Locales.string(context, "enter_valid_info") : null,
                                  onInputChanged: (number) => phoneNumber = number,
                                  cursorColor: AppColors.mainColor,
                                  errorMessage: Locales.string(context, 'enter_valid_info'),
                                  initialValue: phoneNumber,
                                  inputDecoration: InputDecoration(
                                    hintText: Locales.string(context, 'phone'),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: AppColors.greyDark),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: AppColors.mainColor),
                                    ),
                                    errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: AppColors.red),
                                    ),
                                    focusedErrorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(width: 2, color: AppColors.red),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        SocialBoard(
                          facebookOnTap: () => context.read<AuthBloc>().add(AuthFacebookSignUpEvent()),
                          googleOnTap: () => context.read<AuthBloc>().add(AuthGoogleSignUpEvent()),
                          yandexOnTap: () {
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: const EdgeInsets.all(0),
                                insetPadding: EdgeInsets.symmetric(vertical: 40),
                                content: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width - 40,
                                    child: WebView(
                                      initialUrl: ApiRepository.getYandexMail,
                                      javascriptMode: JavascriptMode.unrestricted,
                                      onPageStarted: (url) {
                                        print(url);
                                        if(url.contains(ApiRepository.yandexAppSecret)) {
                                          String token = url.substring(101, 140);
                                          context.read<AuthBloc>().add(AuthYandexSignUpEvent(token: token));
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                          appleOnTap: () => context.read<AuthBloc>().add(AppleSignUpEvent()),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        GestureDetector(
                          onTap: () {
                            if(_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                AuthSignUpStepOne(
                                  email: _emailController.text,
                                  phoneNumber: phoneNumber.phoneNumber != null ? phoneNumber.phoneNumber!.split('+').join('') : "",
                                ),
                              );
                            }
                          },
                          child: AuthMainButton(title: 'next', textColor: Colors.white),
                        ),

                        SizedBox(height: 15),
                        Text(Locales.string(context, 'privacy_policy_text'), textAlign: TextAlign.center,style: AppTextStyles.mainGrey.copyWith(fontSize: 15)),
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
