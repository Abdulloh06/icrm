/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.name,
    required this.image,
    this.lastMessages = '',
  }) : super(key: key);

  final String name;
  final String image;
  final String lastMessages;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Image.asset(image),
            radius: 26,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: UserToken.isDark ? Colors.white : Colors.black),
                    ),
                    Text('5 минут назад', style: AppTextStyles.mainGrey.copyWith(fontSize: 12),),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  lastMessages,
                  overflow: TextOverflow.ellipsis,

                  maxLines: 3,
                  style: TextStyle(fontSize: 12, color: UserToken.isDark ? AppColors.greyLight : Colors.black,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
