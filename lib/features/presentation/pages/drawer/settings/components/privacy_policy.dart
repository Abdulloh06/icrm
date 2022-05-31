import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
      titlePadding: const EdgeInsets.all(20),
      title: LocaleText(
        "privacy_policy",
      ),
      children: [
        LocaleText(
          "privacy_policy_t",
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
