/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:flutter/material.dart';

class LeadMessageCard extends StatelessWidget {
  const LeadMessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.mainDark : AppColors.apColor,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        message,
      ),
    );
  }
}
