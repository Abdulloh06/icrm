/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/cubits/theme_cubit.dart';
import 'package:icrm/features/presentation/pages/seacrh_page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_text_field.dart';

class AppBarBack extends StatelessWidget {
  const AppBarBack({
    Key? key,
    required this.title,
    this.titleWidget = const SizedBox.shrink(),
    this.elevation = 1,
    this.onTap,
  }) : super(key: key);

  final String title;
  final Widget titleWidget;
  final double elevation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap == null ? () => Navigator.pop(context) : onTap,
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios),
                LocaleText(
                  'back',
                  style: AppTextStyles.mainBold.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          title != ""
              ? LocaleText(
                  title,
                  style: AppTextStyles.mainBold.copyWith(fontSize: 25),
                )
              : titleWidget,
        ],
      ),
    );
  }
}

class MainAppBar extends StatelessWidget {
  MainAppBar({
    Key? key,
    this.project = false,
    required this.scaffoldKey,
    required this.title,
    this.isMainColor = false,
    this.elevation = 1,
    this.onTap,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final dynamic title;
  final bool project;
  final bool isMainColor;
  final double elevation;
  final VoidCallback? onTap;

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(builder: (context, state) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: project
            ? Row(children: [
                GestureDetector(
                  onTap: onTap == null ? () => Navigator.pop(context) : onTap,
                  child: Icon(Icons.arrow_back_ios),
                ),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ])
            : title is String ? LocaleText(title) : title,
        elevation: elevation,
        backgroundColor: isMainColor
            ? AppColors.mainDark
            : UserToken.isDark
                ? AppColors.mainColor
                : Colors.white,
        actions: [
          StatefulBuilder(
            builder: (context, setState) {
              return IconButton(
                onPressed: () async {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hint: 'search',
                                    controller: _searchController,
                                    validator: (value) => null,
                                    iconMargin: 10,
                                    suffixIcon: 'assets/icons_svg/search.svg',
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    iconColor: UserToken.isDark ? Colors.white : Colors.black,
                                    isFilled: true,
                                    color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SearchPage(search: _searchController.text),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: SvgPicture.asset(
                  'assets/icons_svg/search.svg',
                  color: UserToken.isDark ? Colors.white : Colors.black,
                ),
              );
            }
          ),
          IconButton(
            onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
            icon: SvgPicture.asset(
              'assets/icons_svg/mainDrawer.svg',
              color: UserToken.isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      );
    });
  }
}

