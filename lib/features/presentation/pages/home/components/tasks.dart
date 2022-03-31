import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Tasks extends StatefulWidget {
  const Tasks({
    Key? key,
  }) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: UserToken.isDark ? AppColors.mainDark : AppColors.apColor,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: MainAppBar(
          scaffoldKey: scaffoldKey,
          title: 'Wonder Woman',
          project: true,
        ),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Разработка UI/UX",
                        style: AppTextStyles.apText,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.pressColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: SvgPicture.asset(
                                "assets/icons_svg/share.svg",
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.pressColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: SvgPicture.asset(
                                "assets/icons_svg/edits.svg",
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,

                  ),
                  Row(
                    children: [
                      Container(
                        child: Center(
                        //  child: Text(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
