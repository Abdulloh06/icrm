import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:avlo/features/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:avlo/features/presentation/pages/auth/pages/local_widgets/auth_text_field.dart';
import 'package:avlo/features/presentation/pages/auth/pages/local_widgets/main_button.dart';
import 'package:avlo/features/presentation/pages/auth/pages/local_widgets/main_button_back.dart';
import 'package:avlo/features/presentation/pages/auth/pages/sign_up/sign_up_page3.dart';
import 'package:avlo/features/presentation/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../../../blocs/auth_bloc/auth_event.dart';

class SignUpPage2 extends StatelessWidget {
  SignUpPage2({Key? key, required this.via, this.password = ''}) : super(key: key);

  final String via;
  final String password;
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      body: BlocConsumer<AuthBloc, AuthStates>(
        listener: (context, state) {
          if(state is AuthSignUpSuccessTwo) {
            if(password == '') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage3(via: state.via)));
            }else {
              context.read<AuthBloc>().add(AuthSignUpConfirmation(via: via, password: password, confirmPassword: password));
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
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
                        Text(
                          Locales.string(context, 'confirmation_text').substring(0, 13) + "+" + via + Locales.string(context, 'confirmation_text').substring(12),
                          style: AppTextStyles.mainGrey,
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
    );
  }
}
