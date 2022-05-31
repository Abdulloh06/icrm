import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class UsingAgreements extends StatelessWidget {
  const UsingAgreements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
      titlePadding: const EdgeInsets.all(20),
      title: LocaleText(
        "using_agreements",
      ),
      children: [
        LocaleText(
          "using_agreements_text",
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
