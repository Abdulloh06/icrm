import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';

class Subtask extends StatelessWidget {
  const Subtask({
    Key? key,
    required this.name,
    required this.assigns,
  }) : super(key: key);

  final String name;
  final List<String> assigns;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8).copyWith(right: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0.1,
            blurRadius: 0.1,
            color: AppColors.greyDark,
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            shape:
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            activeColor: AppColors.greyLight,
            checkColor:
            Colors.white,
            value: true,
            onChanged: (value) {},
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround,
              children: [
                Text(
                  name,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  TextStyle(
                    color: UserToken
                        .isDark
                        ? Colors
                        .white
                        : Colors
                        .black,
                    fontSize: 16,
                    fontWeight:
                    FontWeight
                        .w500,
                  ),
                ),
                const SizedBox(
                    height: 10),
                LinearProgressIndicator(
                  color: AppColors
                      .green,
                  backgroundColor: UserToken
                      .isDark
                      ? Colors
                      .white
                      : AppColors
                      .apColor,
                  value: 0.5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Row(
            children: [
              SizedBox(
                height: 30,
                width: 50,
                child: ListView.builder(
                  itemCount: assigns.isNotEmpty && assigns.length != 1 ? 2 : assigns.isEmpty ? 0 : 1,
                  itemBuilder: (context, index) {
                    return ClipOval(
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          assigns[index],
                        ),
                        radius: 15,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                'assets/icons_svg/next.svg',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
