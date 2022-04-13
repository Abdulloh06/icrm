/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class AuthButtonBack extends StatelessWidget {
  const AuthButtonBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios, size: 20,color: UserToken.isDark ? Colors.white : Colors.grey,),
          LocaleText('back', style: TextStyle(fontSize: 16, color: UserToken.isDark ? Colors.white : Colors.grey),),
        ],
      ),
    );
  }
}
