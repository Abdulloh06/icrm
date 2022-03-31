import 'dart:io';

import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_event.dart';
import 'package:avlo/widgets/custom_text_field.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../blocs/contacts_bloc/contacts_bloc.dart';

class AddParticipant extends StatefulWidget {
  const AddParticipant({Key? key}) : super(key: key);

  @override
  State<AddParticipant> createState() => _AddParticipantState();
}

class _AddParticipantState extends State<AddParticipant> {
  final _userInfoController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _positionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
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

  File? avatar;
  static int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'add_participant',
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => pickImage(),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Builder(
                            builder: (context) {
                              if(avatar != null){
                                return Image.file(File(avatar!.path));
                              }else {
                                return Image.asset('assets/png/no_user.png');
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child:
                                SvgPicture.asset('assets/icons_svg/camera.svg'),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                              height: 25,
                              child: SvgPicture.asset(
                                  'assets/icons_svg/vector.svg')),
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
                        hint: 'user_info',
                        validator: (value) => value!.isEmpty
                            ? Locales.string(context, "must_fill_this_line")
                            : null,
                        controller: _userInfoController,
                        onChanged: (value) => null,
                        isFilled: true,
                        color: UserToken.isDark
                            ? AppColors.cardColorDark
                            : AppColors.textFieldColor,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hint: 'responsibility',
                        validator: (value) => value!.isEmpty
                            ? Locales.string(context, "must_fill_this_line")
                            : null,
                        controller: _positionController,
                        onChanged: (value) {},
                        isFilled: true,
                        color: UserToken.isDark
                            ? AppColors.cardColorDark
                            : AppColors.textFieldColor,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        hint: 'email_address',
                        validator: (value) => value!.isEmpty
                            ? Locales.string(context, "must_fill_this_line")
                            : value.contains('@')
                                ? null
                                : Locales.string(context, 'enter_valid_info'),
                        controller: _emailController,
                        onChanged: (value) {},
                        isFilled: true,
                        color: UserToken.isDark
                            ? AppColors.cardColorDark
                            : AppColors.textFieldColor,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hint: 'phone',
                        validator: (value) => value!.isEmpty
                            ? Locales.string(context, "must_fill_this_line")
                            : value.length < 4
                                ? Locales.string(context, 'enter_valid_info')
                                : null,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {},
                        isFilled: true,
                        color: UserToken.isDark
                            ? AppColors.cardColorDark
                            : AppColors.textFieldColor,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<int>(
                            elevation: 0,
                            itemHeight:
                                MediaQuery.of(context).size.height * 0.09,
                            iconDisabledColor: AppColors.textFieldColor,
                            borderRadius: BorderRadius.circular(10),
                            value: selectedIndex,
                            items: [
                              DropdownMenuItem(
                                value: 1,
                                child: LocaleText('team'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: LocaleText('work'),
                              ),
                              DropdownMenuItem(
                                value: 10,
                                child: LocaleText('other'),
                              ),
                            ],
                            onChanged: (value) => setState(() {
                              selectedIndex = value!;
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: MainButton(
                    color: AppColors.mainColor,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ContactsBloc>().add(ContactsAddEvent(
                          email: _emailController.text,
                          phone_number: _phoneController.text,
                          position: _positionController.text,
                          name: _userInfoController.text,
                          type: selectedIndex,
                          avatar: avatar!,
                        ));
                        Navigator.pop(context);
                      }
                    },
                    title: 'add',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
