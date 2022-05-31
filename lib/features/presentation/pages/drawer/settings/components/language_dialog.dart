import 'package:icrm/core/repository/user_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../core/service/shared_preferences_service.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      children: [
        GestureDetector(
          onTap: () async {
            context.changeLocale('en');
            final _prefs = await SharedPreferences.getInstance();

            await _prefs.setString(PrefsKeys.languageCode, 'en');
            UserToken.languageCode = "en";
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset('assets/png/english.png'),
              ),
              Text(
                "English",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            context.changeLocale('ru');
            final _prefs = await SharedPreferences.getInstance();
            _prefs.setString(PrefsKeys.languageCode, 'ru');
            UserToken.languageCode = "en";
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset('assets/png/russia.png'),
              ),
              Text(
                "Русский",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
