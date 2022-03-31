import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:flutter/material.dart';

class Members extends StatelessWidget {
  Members({Key? key, this.imgSize = 37, required this.memberImagePath}) : super(key: key);
  final String memberImagePath;
  final double imgSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: UserToken.isDark ? AppColors.cardColorDark : Colors.white
        ),
        borderRadius:
        const BorderRadius.all(Radius.circular(23),),),
      child: Image.asset(
        memberImagePath,
        height: imgSize,
      ),
    );
  }
}
