/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.parent_id,
    required this.job,
    required this.name,
    required this.id,
    required this.date,
    required this.message,
    required this.userPhoto,
  }) : super(key: key);

  final String message;
  final String name;
  final String userPhoto;
  final String job;
  final int id;
  final dynamic parent_id;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20).copyWith(top: 0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: userPhoto,
                        errorWidget: (context, error, stack) {
                          return Image.asset('assets/png/no_user.png');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    name,
                    style: AppTextStyles.mainBold.copyWith(
                      color: UserToken.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat(DateFormat.HOUR24_MINUTE).format(DateTime.parse(date)),
                style: AppTextStyles.mainGrey,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: UserToken.isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
