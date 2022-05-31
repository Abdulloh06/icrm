/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';

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
    required this.phone_number,
    required this.email,
  }) : super(key: key);

  final String name;
  final String response;
  final String photo;
  final String phone_number;
  final String email;

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
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: photo,
                        fit: BoxFit.fill,
                        errorWidget: (context, error, stack) {
                          return Image.asset('assets/png/no_user.png');
                        },
                      ),
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
                      Text(
                        response,
                        style: AppTextStyles.mainGrey.copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                  try {
                    String phone = phone_number;
                    phone = phone.split('+').join('');
                    phone = "+" + phone;
                    if(Platform.isIOS) {
                      await launch('tel:// $phone');
                    }else {
                      await launch('tel: $phone');
                    }
                  }catch(e) {
                    print(e);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset('assets/icons_svg/phone.svg', height: 16,),
                ),
              ),
              InkWell(
                splashColor: Colors.grey,
                borderRadius: BorderRadius.circular(20),
                onTap: () async{
                  final Uri _emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: email,
                  );
                  await launch(_emailLaunchUri.toString());
                },
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
