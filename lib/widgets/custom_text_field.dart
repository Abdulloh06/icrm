/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatelessWidget {

  CustomTextField({
    Key? key,
    required this.hint,
    required this.controller,
    required this.validator,
    required this.onChanged,
    this.onTap,
    this.color = AppColors.textFieldColor,
    this.isFilled = true,
    this.suffixIcon = '',
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.isObscure = false,
    this.iconMargin = 0,
    this.borderRadius = 10.0,
    this.maxLines = 1,
    this.boxShadow = const [],
    this.onEditingComplete,
    this.inputFormatters = const [],
    this.iconColor,
    this.onIconTap,
  }) : super(key: key);

  final String hint;
  final String suffixIcon;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool isObscure;
  final bool isFilled;
  final Color color;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final double iconMargin;
  final double borderRadius;
  final int maxLines;
  final VoidCallback? onEditingComplete;
  final List<BoxShadow> boxShadow;
  final List<TextInputFormatter> inputFormatters;
  final Color? iconColor;
  final VoidCallback? onIconTap;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          boxShadow: boxShadow,
        ),
        child: TextFormField(
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          onTap: onTap,
          validator: validator,
          controller: controller,
          cursorColor: AppColors.mainColor,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: suffixIcon != '' ? GestureDetector(
              onTap: onIconTap,
              child: Container(
                margin: EdgeInsets.all(iconMargin).copyWith(bottom: maxLines == 1 ? iconMargin : 70),
                child: iconColor == null ? SvgPicture.asset(suffixIcon) : SvgPicture.asset(suffixIcon, color: iconColor,),
              ),
            ) : null,
            hintText: Locales.string(context, hint),
            hintStyle: const TextStyle(
                fontSize: 16, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColors.greyLight),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: AppColors.mainColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: AppColors.red),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColors.red),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            fillColor: color,
            filled: isFilled,
          ),
          onChanged: (value) => onChanged(value),
          readOnly: readOnly,
          keyboardType: keyboardType,
          obscureText: isObscure,
        ),
      );
  }
}