/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/features/presentation/blocs/profile_bloc/profile_state.dart';
import 'package:icrm/features/presentation/pages/auth/pages/sign_up/sign_up_page2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/main_button.dart';
import '../../../blocs/profile_bloc/profile_bloc.dart';
import '../../../blocs/profile_bloc/profile_event.dart';

class ChangeUserInfoDialog extends StatefulWidget {
  const ChangeUserInfoDialog({Key? key,}) : super(key: key);

  @override
  State<ChangeUserInfoDialog> createState() => _ChangeUserInfoDialogState();
}

class _ChangeUserInfoDialogState extends State<ChangeUserInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  File? avatar;
  void pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if(image != null) {
        setState(() {
          avatar = File(image.path);
        });
      }
    } catch (error) {
      print(error);
    }
  }

  ProfileInitState? profile;

  String email = "";
  String phone_number = "";

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _nameController.text = UserToken.name;
    _surnameController.text = UserToken.surname;
    _emailController.text = UserToken.email;
    _userNameController.text = UserToken.username;
    _phoneController.text = UserToken.phoneNumber;
    _jobController.text = UserToken.responsibility;
    phone_number = _phoneController.text;
    email = _emailController.text;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if(state is ProfileSuccessState) {
          Navigator.pop(context);
          if(profile != null
              && profile!.profile.phone_number.isEmpty
              && _phoneController.text.isNotEmpty
              || phone_number.split(' ').join('') != _phoneController.text.split(' ').join()
          ) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage2(
              via: _phoneController.text.split('+').join(''),
              fromProfile: true,
            )));
          }else if(profile != null
              && profile!.profile.email.isEmpty
              && _emailController.text.isNotEmpty
              || email.split(' ').join() != _emailController.text.split(' ').join()
          ) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage2(
              fromProfile: true,
              via: _emailController.text,
            )));
          }
          context.read<ProfileBloc>().add(ProfileInitEvent());
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
          Navigator.pop(context);
          context.read<ProfileBloc>().add(ProfileInitEvent());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if(state is ProfileInitState) {
            profile = state;
            print(state.profile.email);
            print(state.profile.phone_number);
            _emailController.text = profile!.profile.email;
            _phoneController.text = profile!.profile.phone_number;
          }
          return SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                Locales.string(context, 'change_profile_info'),
                textAlign: TextAlign.center,
                style: AppTextStyles.mainBold.copyWith(fontSize: 20),
              ),
              insetPadding: const EdgeInsets.only(top: 30),
              content: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 55,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              height: 110,
                              width: 110,
                              child: ClipOval(
                                child: Builder(
                                  builder: (context) {
                                    if(avatar == null) {
                                      return CachedNetworkImage(
                                        imageUrl: UserToken.userPhoto,
                                        fit: BoxFit.fill,
                                        errorWidget: (context, error, stack) {
                                          return Image.asset('assets/png/no_user.png');
                                        },
                                      );
                                    }else {
                                      return Image.file(
                                        avatar!,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  }
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child:
                              SvgPicture.asset('assets/icons_svg/camera.svg'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child:
                            SvgPicture.asset('assets/icons_svg/vector.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          isFilled: true,
                          color: UserToken.isDark
                              ? AppColors.textFieldColorDark
                              : AppColors.textFieldColor,
                          validator: (val) => val!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                          hint: 'name',
                          controller: _nameController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          isFilled: true,
                          color: UserToken.isDark
                              ? AppColors.textFieldColorDark
                              : AppColors.textFieldColor,
                          validator: (val) => val!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                          hint: 'surname',
                          controller: _surnameController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          isFilled: true,
                          color: UserToken.isDark
                              ? AppColors.textFieldColorDark
                              : AppColors.textFieldColor,
                          validator: (value) => value!.isEmpty
                              ? null : value.length >= 4
                              ? null : Locales.string(context, "min_four_symbols"),
                          hint: 'username',
                          controller: _userNameController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          isFilled: true,
                          color: UserToken.isDark
                              ? AppColors.textFieldColorDark
                              : AppColors.textFieldColor,
                          validator: (val) => null,
                          hint: 'job',
                          controller: _jobController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          isFilled: true,
                          color: UserToken.isDark
                              ? AppColors.textFieldColorDark
                              : AppColors.textFieldColor,
                          validator: (val) => null,
                          hint: 'email',
                          controller: _emailController,
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          isFilled: true,
                          color: UserToken.isDark
                              ? AppColors.textFieldColorDark
                              : AppColors.textFieldColor,
                          validator: (val) => val!.isEmpty
                              ? null
                              : val.length < 6
                              ? Locales.string(context, "invalid_phone_number")
                              : null,
                          hint: 'number_phone',
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MainButton(
                          fontSize: 15,
                          color: AppColors.red,
                          title: 'cancel',
                          onTap: () => Navigator.pop(context),
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: context.currentLocale!.languageCode == 'ru' ? 35 : 50,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        MainButton(
                          fontSize: 15,
                          color: AppColors.mainColor,
                          title: 'done',
                          onTap: () {
                            if(avatar != null) {
                              context.read<ProfileBloc>().add(ProfileChangePhotoEvent(avatar: avatar!));
                            }
                            if(_formKey.currentState!.validate()) {
                              context.read<ProfileBloc>().add(
                                ProfileChangeEvent(
                                  name: _nameController.text,
                                  surname: _surnameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text.split('+').join(''),
                                  username: _userNameController.text,
                                  job: _jobController.text,
                                ),
                              );
                            }
                          },
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: context.currentLocale!.languageCode == 'ru' ? 35 : 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
