/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/cubits/auth_page_slider_cubit.dart';
import 'package:icrm/features/presentation/pages/auth/pages/local_widgets/auth_pages.dart';
import 'package:icrm/features/presentation/pages/auth/pages/local_widgets/main_button.dart';
import 'package:icrm/features/presentation/pages/auth/pages/login/login.dart';
import 'package:icrm/features/presentation/pages/auth/pages/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthMainPage extends StatelessWidget {
  AuthMainPage({Key? key}) : super(key: key);


  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 52),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'icrm CRM',
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) => context.read<AuthPageSliderCubit>().changePage(index),
                      children: [
                        Auth1(),
                        Auth2(),
                        Auth3(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: ColoredBox(
        color: UserToken.isDark ? AppColors.mainDark : Colors.white,
        child: BlocBuilder<AuthPageSliderCubit, int>(
          builder: (context, value) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.22,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Switcher(value: 1, isActive: value == 0, pageController: _pageController,),
                      Switcher(value: 2, isActive: value == 1, pageController: _pageController,),
                      Switcher(value: 3, isActive: value == 2, pageController: _pageController,),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Login())),
                    child: AuthMainButton(
                      title: 'login',
                      color: UserToken.isDark ? AppColors.mainDark : Colors.white,
                      textColor: UserToken.isDark ? Colors.white : AppColors.mainColor,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp())),
                    child: AuthMainButton(
                      title: "sign_up",
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}

class Switcher extends StatelessWidget {
  const Switcher({Key? key, required this.value, required this.isActive, required this.pageController}) : super(key: key);

  final int value;
  final bool isActive;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: GestureDetector(
        onTap: () {
          context.read<AuthPageSliderCubit>().changePage(value - 1);
          pageController.jumpToPage(value -1);
        },
        child: CircleAvatar(
          radius: 10,
          backgroundColor: isActive ? AppColors.mainColor : AppColors.greyLight,
          child: Text(value.toString(), style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
