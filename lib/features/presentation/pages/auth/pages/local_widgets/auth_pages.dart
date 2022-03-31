
import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Auth1 extends StatelessWidget {
  const Auth1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 70),
        Center(
          child: SizedBox(
            height: 186,
            child: Image.asset('assets/png/auth1.png'),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        LocaleText(
          'control_business_process',
          style: AppTextStyles.mainBold.copyWith(fontSize: 22, color: UserToken.isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(
          height: 15,
        ),
        LocaleText(
          'auth1',
          style: AppTextStyles.mainGrey,
        ),
      ],
    );
  }
}

class Auth2 extends StatelessWidget {
  const Auth2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            height: 237,
            child: Image.asset('assets/png/auth2.png'),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        LocaleText(
          'control_deal',
          style: AppTextStyles.mainBold.copyWith(fontSize: 22, color: UserToken.isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(
          height: 15,
        ),
        LocaleText(
          'auth2',
          style: AppTextStyles.mainGrey
        ),
      ],
    );
  }
}

class Auth3 extends StatelessWidget {
  const Auth3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Center(
          child: SizedBox(
            height: 230,
            child: Stack(
              children: [
                Image.asset('assets/png/ellipse.png'),
                Image.asset('assets/png/auth3.png'),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        LocaleText(
          'auth3Main',
          style: AppTextStyles.mainBold.copyWith(fontSize: 22, color: UserToken.isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(
          height: 15,
        ),
         LocaleText(
          'auth3',
          style: AppTextStyles.mainGrey,
        ),
      ],
    );
  }
}


