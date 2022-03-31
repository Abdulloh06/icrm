import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    Key? key,
    required this.category,
    required this.taskTitle,
    required this.percent,
  }) : super(key: key);

  final String taskTitle;
  final String category;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          UserToken.isDark ? BoxShadow() : BoxShadow(
            color: Colors.black54,
            spreadRadius: 0.1,
            blurRadius: 0.1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(taskTitle, style: AppTextStyles.mainBold.copyWith(fontSize: 18)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('description', style: AppTextStyles.mainGrey.copyWith(fontSize: 12),),
                  const SizedBox(height: 15,),
                  LocaleText('team', style: AppTextStyles.mainBold.copyWith(fontSize: 12),),
                  const SizedBox(height: 10,),
                  Container(
                    width: 100,
                    child: Stack(
                      children: [
                        Positioned(
                          child: CircleAvatar(
                            radius: 16,
                            child: Image.asset('assets/png/avatar.png'),
                          ),
                        ),
                        Positioned(
                          left: 33,
                          child: CircleAvatar(
                            radius: 16,
                            child: Image.asset('assets/png/img.png'),
                          ),
                        ),
                        Positioned(
                          left: 65,
                          child: CircleAvatar(
                            radius: 16,
                            child: SvgPicture.asset('assets/icons_svg/add_icon.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 55.0,
                lineWidth: 8.0,
                percent: percent / 100,
                center: Text(percent.round().toString() + '%', style: AppTextStyles.mainBold,),
                progressColor: AppColors.green,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons_svg/calendar.svg', height: 18,),
                    const SizedBox(width: 10,),
                    Text(DateFormat('yyyy-MM-dd').format(DateTime.now()) + " - " + DateFormat('yyyy-MM-dd').format(DateTime.now()), style: TextStyle(fontSize: 12),),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: false,
                      onChanged: (value) {},
                    ),
                    Flexible(child: Text('8 ' + Locales.string(context, "subtasks"), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
