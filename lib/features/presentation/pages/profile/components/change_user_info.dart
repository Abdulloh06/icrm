import 'dart:io';

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
  ChangeUserInfoDialog({
    Key? key,
    required this.nameController,
    required this.surnameController,
    required this.emailController,
    required this.phoneController,
    required this.userNameController,
    required this.jobController,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController jobController;

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor:
        UserToken.isDark ? AppColors.mainDark : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(
          Locales.string(context, 'change_profile_info'),
          textAlign: TextAlign.center,
          style: AppTextStyles.mainBold.copyWith(fontSize: 20),
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        insetPadding: const EdgeInsets.only(top: 50, bottom: 50),
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
                      child: ClipOval(
                        child: Builder(
                          builder: (context) {
                            if(avatar == null) {
                              return CachedNetworkImage(
                                imageUrl: UserToken.userPhoto,
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
                  SizedBox(
                    height: 40,
                    child: CustomTextField(
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                      validator: (val) => val!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                      hint: 'name',
                      controller: widget.nameController,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: CustomTextField(
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                      validator: (val) => val!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                      hint: 'surname',
                      controller: widget.surnameController,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: CustomTextField(
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                      validator: (val) => null,
                      hint: 'username',
                      controller: widget.userNameController,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: CustomTextField(
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                      validator: (val) => val!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                      hint: 'job',
                      controller: widget.jobController,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: CustomTextField(
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                      validator: (val) => val!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                      hint: 'email',
                      controller: widget.emailController,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: CustomTextField(
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                      validator: (val) => val!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                      hint: 'number_phone',
                      controller: widget.phoneController,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 65),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MainButton(
                    fontSize: 15,
                    color: AppColors.red,
                    title: 'cancel',
                    onTap: () => Navigator.pop(context),
                    padding: UserToken.languageCode == 'ru' ? const EdgeInsets.symmetric(vertical: 15, horizontal: 40) : const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  ),
                  const SizedBox(
                    width: 30,
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
                            name: widget.nameController.text,
                            surname: widget.surnameController.text,
                            email: widget.emailController.text,
                            phone: widget.phoneController.text,
                            username: widget.userNameController.text,
                            job: widget.jobController.text,
                          ),
                        );
                      }
                      print(UserToken.languageCode);
                      Navigator.pop(context);
                    },
                    padding: UserToken.languageCode == 'ru' ? const EdgeInsets.symmetric(vertical: 15, horizontal: 40) : const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
