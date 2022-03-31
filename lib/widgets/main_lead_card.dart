import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainLeadCard extends StatelessWidget {
  const MainLeadCard({
    Key? key,
    required this.title,
    required this.client1,
    required this.client2,
    required this.price,
    required this.date,
    required this.leadColor,
    required this.last,
    this.priorityColor = Colors.transparent,
    this.priority = '',
  }) : super(key: key);

  final String title;
  final String client1;
  final String client2;
  final String priority;
  final double price;
  final String last;
  final String date;
  final Color leadColor;
  final Color priorityColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 10,
            height: priority == '' ? 170 : 176,
            decoration: BoxDecoration(
              color: leadColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: priority == '' ? 170 : 176,
              decoration: BoxDecoration(
                color:
                    UserToken.isDark ? AppColors.cardColorDark : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.apText.copyWith(
                                color: UserToken.isDark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          priority == ''
                              ? SvgPicture.asset("assets/icons_svg/dot.svg")
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: priorityColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    priority,
                                    style: TextStyle(color: leadColor),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      title,
                      style: AppTextStyles.apText.copyWith(
                          fontSize: 12,
                          color:
                              UserToken.isDark ? Colors.white : Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(client1),
                        SizedBox(
                          width: 14,
                        ),
                        SvgPicture.asset("assets/icons_svg/dottt.svg"),
                        SizedBox(
                          width: 14,
                        ),
                        Text(client2),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.8,
                          child: Text(
                            last,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        Text(
                          "${price}",
                          style: AppTextStyles.apText.copyWith(
                              color: UserToken.isDark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons_svg/calen.svg'),
                            SizedBox(
                              width: 8,
                            ),
                            Text(date)
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: AppColors.greyText,
                                  ),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: SvgPicture.asset(
                                    'assets/icons_svg/call.svg'),
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.greyText,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                    'assets/icons_svg/mess.svg'),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
