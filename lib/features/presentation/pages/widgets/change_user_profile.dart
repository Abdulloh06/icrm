/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_event.dart';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_state.dart';
import 'package:icrm/features/presentation/pages/auth/pages/sign_up/sign_up_page2.dart';
import 'package:icrm/features/presentation/pages/main/main_page.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/service/shared_preferences_service.dart';
import '../../../../core/util/text_styles.dart';
import '../../../../widgets/custom_text_field.dart';

class ChangeUserProfile extends StatefulWidget {
  const ChangeUserProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeUserProfile> createState() => _ChangeUserProfileState();
}

class _ChangeUserProfileState extends State<ChangeUserProfile> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _jobController = TextEditingController();
  ProfileInitState? profile;

  final _formKey = GlobalKey<FormState>();

  final _imagePicker = ImagePicker();
  static XFile? _userImage;
  static String? _path;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _jobController.dispose();
    _phoneNumberController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if(state is ProfileSuccessState) {
          if(profile != null && profile!.profile.phone_number.isEmpty && _phoneNumberController.text.isNotEmpty) {
            SharedPreferencesService.instance.then((value) => value.setAuth(true));
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage2(
              fromProfile: true,
              via: _phoneNumberController.text.split('+').join(''),
            )));
          } else if(profile != null && profile!.profile.email.isEmpty && _emailController.text.isNotEmpty) {
            SharedPreferencesService.instance.then((value) => value.setAuth(true));
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage2(
              fromProfile: true,
              via: _emailController.text,
            )));
          } else {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              return MainPage(
                isMain: false,
              );
            }), (route) => false);
            SharedPreferencesService.instance.then((value) => value.setAuth(true));
          }
        }
        if(state is ProfileErrorState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(20),
              backgroundColor: AppColors.mainColor,
              content: LocaleText(state.error, style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
            ),
          );
          context.read<ProfileBloc>().add(ProfileInitEvent());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if(state is ProfileInitState) {
            profile = state;
            print(state.profile.phone_number);
            _nameController.text = state.profile.first_name;
            _surnameController.text = state.profile.last_name;
            _phoneNumberController.text = state.profile.phone_number;
            _emailController.text = state.profile.email;
            _usernameController.text = state.profile.username;
            return Scaffold(
              body: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              try {
                                _userImage = await _imagePicker.pickImage(source: ImageSource.gallery);
                                _path = _userImage!.path;
                                setState(() {});
                              }catch(_) {}
                            },
                            child: CircleAvatar(
                              radius: 50,
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Builder(
                                        builder: (context) {
                                          if(_path != null) {
                                            return Image.asset(_path!, fit: BoxFit.cover);
                                          }else {
                                            return Image.asset('assets/png/no_user.png');
                                          }
                                        } ,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SvgPicture.asset('assets/icons_svg/camera.svg'),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SvgPicture.asset('assets/icons_svg/vector.svg'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _nameController,
                                  hint: 'name',
                                  onChanged: (value) {},
                                  validator: (value) =>
                                  value!.isEmpty ? Locales.string(
                                      context, 'must_fill_this_line') : null,
                                  isFilled: true,
                                  color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  controller: _surnameController,
                                  hint: 'surname',
                                  onChanged: (value) {},
                                  validator: (value) =>
                                  value!.isEmpty ? Locales.string(
                                      context, 'must_fill_this_line') : null,
                                  isFilled: true,
                                  color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  controller: _usernameController,
                                  hint: 'username',
                                  onChanged: (value) {},
                                  validator: (value) => value!.isEmpty
                                      ? null : value.length >= 4
                                      ? null : Locales.string(context, "min_four_symbols"),
                                  isFilled: true,
                                  color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  controller: _emailController,
                                  hint: 'email',
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {},
                                  validator: (value) => value!.isEmpty ? null :
                                  value.length < 7 ? Locales.string(context, "enter_valid_info") : value.contains('@')
                                      ? null
                                      : Locales.string(context, "enter_valid_info"),
                                  isFilled: true,
                                  color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  controller: _jobController,
                                  hint: 'job',
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {},
                                  validator: (value) => null,
                                  isFilled: true,
                                  color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 15),
                                CustomTextField(
                                  controller: _phoneNumberController,
                                  hint: 'phone',
                                  onChanged: (value) {},
                                  keyboardType: TextInputType.phone,
                                  validator: (value) => null,
                                  isFilled: true,
                                  color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          MainButton(
                            color: AppColors.mainColor,
                            title: 'save',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ProfileBloc>().add(
                                  ProfileChangeEvent(
                                    name: _nameController.text,
                                    surname: _surnameController.text,
                                    email: _emailController.text,
                                    phone: _phoneNumberController.text.split('+').join(''),
                                    username: _usernameController.text,
                                    job: _jobController.text,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            child: LocaleText(
                              "skip",
                              style: TextStyle(color: AppColors.mainColor),
                            ),
                            onPressed: () {
                              SharedPreferencesService.instance.then((value) => value.setAuth(true));
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }else {
            return Scaffold(
              body: Loading(),
            );
          }
        }
      ),
    );
  }
}
