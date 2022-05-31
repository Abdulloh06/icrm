/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/service/shared_preferences_service.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:icrm/features/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_event.dart';
import 'package:icrm/features/presentation/pages/auth/pages/sign_up/sign_up_page3.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../../../blocs/auth_bloc/auth_event.dart';
import '../../../main/main_page.dart';
import '../../local_widgets/auth_text_field.dart';
import '../../local_widgets/main_button.dart';
import '../../local_widgets/main_button_back.dart';

class SignUpPage2 extends StatelessWidget {
  SignUpPage2({
    Key? key,
    required this.via,
    this.fromProfile = false,
  }) : super(key: key);

  final String via;
  final bool fromProfile;
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(fromProfile) {
          context.read<ProfileBloc>().add(ProfileInitEvent());
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
        body: BlocConsumer<AuthBloc, AuthStates>(
          listener: (context, state) {
            if(state is AuthSignUpSuccessTwo) {
              if(fromProfile) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(
                  isMain: false,
                )));
                SharedPreferencesService.instance.then((value) => value.setAuth(true));
              }else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage3(via: state.via)));
              }
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
                              AuthButtonBack(
                                onTap: () {
                                  if(fromProfile) {
                                    context.read<ProfileBloc>().add(ProfileInitEvent());
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                'I CRM',
                                style: AppTextStyles.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: 70),
                          LocaleText(
                            'confirmation',
                            style: AppTextStyles.mainBold.copyWith(fontSize: 22),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Builder(
                            builder: (context) {
                              if(via.contains('@')) {
                                String text = Locales.string(context, 'confirmation_text').replaceAll("{}", via);
                                if(UserToken.languageCode == 'ru') {
                                  text = text.replaceAll("ваш номер", "вашу почту");
                                }else {
                                  text = text.replaceAll("number", "email");
                                }
                                return Text(
                                  text,
                                  style: AppTextStyles.mainGrey,
                                );
                              }else {
                                return Text(
                                  Locales.string(context, 'confirmation_text').replaceAll('{}', via),
                                  style: AppTextStyles.mainGrey,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 60),
                          Form(
                            key: _formKey,
                            child: AuthTextField(
                              title: Locales.string(context, 'code'),
                              controller: _codeController,
                              validator: (value) =>
                              value!.isEmpty ? Locales.string(context, "must_fill_this_line") : value.length < 4 ? Locales.string(context, "enter_valid_info") : null,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            height: 261,
                          ),
                          GestureDetector(
                            onTap: () {
                              if(_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(AuthSignUpStepTwo(via: via, code: int.parse(_codeController.text)));
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
      ),
    );
  }
}
