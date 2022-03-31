import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectedMessage extends StatelessWidget {
  const SelectedMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 23),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset('assets/icons_svg/menu_icon.svg', color: UserToken.isDark ? Colors.white : Colors.black, height: 20,),
            ),
          ),
        ],
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios, size: 20),
            ),
            const SizedBox(width: 5,),
            CircleAvatar(
              child: Image.asset('assets/png/img_1.png'),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Джейн Купер', style: TextStyle(fontSize: 16),),
                Text('был(а) недавно', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),)
              ],
            ),
          ],
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            children: [

            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 80,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: UserToken.isDark ? AppColors.mainDark : Colors.white,
          //borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: UserToken.isDark ? [] : [
            BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 1,
                blurRadius: 1
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: UserToken.isDark ? AppColors.mainDark : Color.fromRGBO(241, 244, 247, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            cursorColor: AppColors.mainColor,

            decoration: InputDecoration(
              prefixIcon: CircleAvatar(
                backgroundColor: Color.fromRGBO(220, 223, 227, 1),
                child: SvgPicture.asset('assets/icons_svg/clip.svg', height: 14),
              ),
              border: InputBorder.none,
              hintText: 'Написать сообщение ...',
              suffixIcon: Container(
                width: 80,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: UserToken.isDark ? Color.fromRGBO(220, 223, 227, 1) : AppColors.mainColor,
                      child: SvgPicture.asset('assets/icons_svg/smile.svg', color: UserToken.isDark ? Colors.black : Colors.white, height: 14),
                    ),
                    CircleAvatar(
                      backgroundColor: UserToken.isDark ? Color.fromRGBO(220, 223, 227, 1) : AppColors.mainColor,
                      child: SvgPicture.asset('assets/icons_svg/microphone.svg', color: UserToken.isDark ? Colors.black : Colors.white, height: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
