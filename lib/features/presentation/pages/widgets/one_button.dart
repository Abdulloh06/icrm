import 'package:avlo/core/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class OneButtonWidget extends StatelessWidget {
  final VoidCallback press;
  const OneButtonWidget({
    Key? key,
    required this.press
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 10),
      height: 56,
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
        onPressed: press,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(AppColors.AppColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              // side: BorderSide(width: 0.3, color: Colors.red),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            Locales.string(context, 'save'),
            style: TextStyle(color: AppColors.btnTextCol, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
