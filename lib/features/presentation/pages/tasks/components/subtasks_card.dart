import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';

class Subtask extends StatelessWidget {
  const Subtask({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 8)
          .copyWith(right: 10),
      decoration: BoxDecoration(
        color: UserToken.isDark
            ? AppColors
            .cardColorDark
            : Colors.white,
        borderRadius:
        BorderRadius.circular(
            10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0.1,
            blurRadius: 0.1,
            color: AppColors
                .greyDark,
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius
                  .circular(
                  5),
            ),
            activeColor: AppColors
                .greyLight,
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
              CircleAvatar(
                backgroundImage:
                AssetImage(
                    'assets/png/img.png'),
              ),
              CircleAvatar(
                backgroundImage:
                AssetImage(
                    'assets/png/img.png'),
              ),
              const SizedBox(
                  width: 10),
              SvgPicture.asset(
                  'assets/icons_svg/next.svg'),
            ],
          ),
        ],
      ),
    );
  }
}
