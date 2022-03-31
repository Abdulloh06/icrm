import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainSearchBar extends StatelessWidget {
  const MainSearchBar({
    Key? key,
    this.fillColor = AppColors.textFieldColor,
    required this.controller,
    required this.onComplete,
    this.borderWidth = 1,
    required this.onChanged,
  })
      : super(key: key);
  final TextEditingController controller;
  final Color fillColor;
  final VoidCallback onComplete;
  final ValueChanged onChanged;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColors.mainColor,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.grey, height: 0.6),
        hintText: Locales.string(context, 'search'),
        fillColor: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: UserToken.isDark
                  ? AppColors.cardColorDark
                  : AppColors.textFieldColor,
              width: borderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.mainColor, width: borderWidth),
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons_svg/search.svg',
              color: AppColors.greyDark,height: 10, width: 10,),
        ),
      ),
      onChanged: onChanged,
      onEditingComplete: onComplete,
    );
  }
}