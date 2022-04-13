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
import 'package:icrm/widgets/main_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();

  void changeUserInfo(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ChangeUserInfoDialog(
          nameController: _nameController,
          surnameController: _surnameController,
          emailController: _emailController,
          jobController: _jobController,
          phoneController: _phoneController,
          userNameController: _userNameController,
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        print('smt');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = UserToken.name;
    _surnameController.text = UserToken.surname;
    _emailController.text = UserToken.email;
    _userNameController.text = UserToken.username;
    _phoneController.text = UserToken.phoneNumber;
    _jobController.text = UserToken.responsibility;
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
                                    '0',
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
                                            shape: BoxShape.rectangle,
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
                                  child: ClipOval(
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
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '0',
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.26),
                            child: MainButton(
                              onTap: () async => changeUserInfo(context),
                              title: 'edit',
                              color: AppColors.mainColor,
                              borderRadius: 8,
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
                child: Column(
                  children: [
                    BlocBuilder<ThemeCubit, bool>(builder: (context, state) {
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
                                onChanged: (value) => context.read<ThemeCubit>().changeTheme(value),
                              ),
                            ],
                          ),
                          ProfileMainCategories(),
                        ],
                      );
                    }),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                insetPadding: const EdgeInsets.symmetric(),
                                title: Text(
                                  Locales.string(
                                      context, 'you_want_delete_profile'),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.mainBold
                                      .copyWith(fontSize: 22),
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      MainButton(
                                        color: AppColors.red,
                                        title: 'no',
                                        onTap: () => Navigator.pop(context),
                                        fontSize: 22,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 10),
                                      ),
                                      MainButton(
                                        onTap: () {},
                                        color: AppColors.mainColor,
                                        title: 'yes',
                                        fontSize: 22,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                          },
                        );
                      },
                      child: LocaleText('delete_profile',
                          style: const TextStyle(color: AppColors.red)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
