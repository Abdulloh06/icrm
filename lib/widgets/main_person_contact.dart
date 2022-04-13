/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPersonContact extends StatelessWidget {
  const MainPersonContact({
    Key? key,
    required this.name,
    required this.photo,
    required this.response,
    this.phone_number = '',
  }) : super(key: key);

  final String name;
  final String response;
  final String photo;
  final String phone_number;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: photo,
                      errorWidget: (context, error, stack) {
                        return Image.asset('assets/png/no_user.png');
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.mainBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(response, style: AppTextStyles.mainGrey.copyWith(fontSize: 12), overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  await launch('tel: $phone_number');
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset('assets/icons_svg/phone.svg', height: 16,),
                ),
              ),
              InkWell(
                splashColor: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Ink(
                  padding: const EdgeInsets.all(5),
                  child: SvgPicture.asset('assets/icons_svg/chat.svg', height: 16,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
