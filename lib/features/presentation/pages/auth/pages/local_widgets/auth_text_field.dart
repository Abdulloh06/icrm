import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

//ignore:must_be_immutable
class AuthTextField extends StatelessWidget {
  AuthTextField({
    Key? key,
    required this.title,
    required this.controller,
    required this.validator,
    this.onTap,
    this.margin = 0,
    this.helperText = '',
    this.suffixIcon = '',
    this.keyboardType = TextInputType.text,
    this.isObscure = false,
    this.hint = '',

  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final String helperText;
  final double margin;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final String suffixIcon;
  final String hint;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != '',
          child: Container(
            margin: const EdgeInsets.all(5),
            child: Text(title, style: AppTextStyles.mainGrey,),
          ),
        ),
        TextFormField(
          obscureText: isObscure,
          validator: validator,
          controller: controller,
          cursorColor: AppColors.mainColor,
          decoration: InputDecoration(
            helperText: helperText,
            hintText: LocaleText(hint).k,
            suffixIcon: suffixIcon != '' ? Container(
              margin: EdgeInsets.all(margin),
              child: GestureDetector(
                onTap: onTap,
                child: SvgPicture.asset(suffixIcon),
              ),
            ) : null,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.greyDark),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.mainColor),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.red),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.red),
            ),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
