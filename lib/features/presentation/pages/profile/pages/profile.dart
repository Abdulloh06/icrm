/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/cubits/theme_cubit.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_state.dart';
import 'package:icrm/features/presentation/pages/profile/components/change_user_info.dart';
import 'package:icrm/features/presentation/pages/profile/components/profile_main_categories.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  void changeUserInfo(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ChangeUserInfoDialog();
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: MainAppBar(
          title: 'my_profile',
          scaffoldKey: widget.scaffoldKey,
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25)),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0).copyWith(top: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    UserToken.completedTask.toString(),
                                    style: AppTextStyles.primary,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  LocaleText('finished',
                                      style: AppTextStyles.mainGrey
                                          .copyWith(fontSize: 14)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CachedNetworkImage(
                                            placeholder: (context, data) {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  color: AppColors.mainColor,
                                                ),
                                              );
                                            },
                                            imageUrl: UserToken.userPhoto,
                                            errorWidget: (context, error, stackTrace) {
                                              return Image.asset('assets/png/no_user.png');
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 55,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.grey,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        placeholder: (context, data) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.mainColor,
                                            ),
                                          );
                                        },
                                        fit: BoxFit.fill,
                                        imageUrl: UserToken.userPhoto,
                                        errorWidget: (context, error, stackTrace) {
                                          String name = UserToken.name[0];
                                          String surname = "";
                                          if(UserToken.surname.isNotEmpty) {
                                            surname = UserToken.surname[0];
                                          }
                                          return Center(
                                            child: Text(
                                              name + surname,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 33,
                                                color: UserToken.isDark
                                                    ? Colors.white
                                                    : Colors.grey.shade600,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    UserToken.inProgressTask.toString(),
                                    style: AppTextStyles.primary,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  LocaleText('in_progress',
                                      style: AppTextStyles.mainGrey
                                          .copyWith(fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            UserToken.name + " " + UserToken.surname,
                            style:
                                AppTextStyles.mainBold.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            UserToken.responsibility,
                            style:
                                AppTextStyles.mainGrey.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(AppColors.mainColor),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  horizontal: context.currentLocale!.languageCode == 'ru' ? 30 : 60,
                                  vertical: 15,
                                ),
                              ),
                            ),
                            onPressed: () {
                              changeUserInfo(context);
                            },
                            child: const LocaleText(
                              "edit",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: BlocBuilder<ThemeCubit, bool>(builder: (context, state) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LocaleText(
                            'dark_theme',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Switch(
                            value: state,
                            onChanged: (value) {
                              context.read<ThemeCubit>().changeTheme(value);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      ProfileMainCategories(),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
