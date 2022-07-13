/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';

import 'package:icrm/core/models/contacts_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_event.dart';
import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_state.dart';
import 'package:icrm/widgets/custom_text_field.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/util/text_styles.dart';
import '../../../blocs/contacts_bloc/contacts_bloc.dart';

class AddParticipant extends StatefulWidget {
  const AddParticipant({
    Key? key,
    this.fromEdit = false,
    this.contact,
  }) : super(key: key);

  final bool fromEdit;
  final ContactModel? contact;

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
  int selectedIndex = 1;
  String indexName = "team";

  @override
  void initState() {
    super.initState();
    if(widget.fromEdit) {
      _userInfoController.text = widget.contact!.name;
      _emailController.text = widget.contact!.email;
      _positionController.text = widget.contact!.position;
      _phoneController.text = widget.contact!.phone_number;
      selectedIndex = widget.contact!.contact_type;
      switch(widget.contact!.contact_type) {
        case 1:
          indexName = "team";
          break;
        case 2:
          indexName = "work";
          break;
        case 3:
          indexName = "other";
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'add_participant',
        ),
      ),
      body: BlocListener<ContactsBloc, ContactsState>(
        listener: (context, state) {
          if(state is ContactsAddState) {
            context.read<ContactsBloc>().add(ContactsInitEvent());
            Navigator.pop(context);
          }
          if(state is ContactsErrorState) {
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
          }
        },
        child: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if(state is ContactsLoadingState) {
              return Loading();
            }else {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => pickImage(),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.transparent,
                            child: Stack(
                              children: [
                                Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: ClipOval(
                                    child: Builder(
                                      builder: (context) {
                                        if(avatar != null){
                                          return Image.file(
                                            File(avatar!.path),
                                            fit: BoxFit.fill,
                                          );
                                        }else {
                                          if(widget.fromEdit) {
                                            return CachedNetworkImage(
                                              imageUrl: widget.contact!.avatar,
                                              placeholder: (context, child) {
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    color: AppColors.mainColor,
                                                  ),
                                                );
                                              },
                                              fit: BoxFit.fill,
                                              errorWidget: (context, error, stack) {
                                                return Image.asset(
                                                  'assets/png/no_user.png',
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                            );
                                          }else {
                                            return Image.asset(
                                              'assets/png/no_user.png',
                                              fit: BoxFit.fill,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SvgPicture.asset(
                                      'assets/icons_svg/camera.svg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 60),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: SvgPicture.asset(
                                        'assets/icons_svg/vector.svg',
                                      ),
                                    ),
                                  ),
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
                                validator: (value) => null,
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
                                validator: (value) => value!.isEmpty ? null : value.contains('@') ? null : Locales.string(context, 'enter_valid_info'),
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
                                    ? null
                                    : value.length < 6
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
                              PopupMenuButton<int>(
                                offset: Offset(
                                  MediaQuery.of(context).size.width / 2,
                                  0,
                                ),
                                onSelected: (value) {
                                  selectedIndex = value;
                                  switch(value) {
                                    case 1:
                                      indexName = "team";
                                      break;
                                    case 2:
                                      indexName = "work";
                                      break;
                                    case 10:
                                      indexName = "other";
                                      break;
                                  }
                                  setState(() {});
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 1,
                                      child: LocaleText('team'),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: LocaleText('work'),
                                    ),
                                    PopupMenuItem(
                                      value: 10,
                                      child: LocaleText('other'),
                                    ),
                                  ];
                                },
                                child: Container(
                                  height: 48,
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: UserToken.isDark
                                        ? AppColors.cardColorDark
                                        : AppColors.textFieldColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.greyLight,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    Locales.string(context, indexName),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: UserToken.isDark ? Colors.white : Colors.black,
                                    ),
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
                                if(widget.fromEdit) {
                                  context.read<ContactsBloc>().add(
                                    ContactsUpdateEvent(
                                      id: widget.contact!.id,
                                      type: selectedIndex,
                                      avatar: avatar,
                                      name: _userInfoController.text,
                                      phone_number: _phoneController.text,
                                      position: _positionController.text,
                                      email: _emailController.text,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }else {
                                  context.read<ContactsBloc>().add(ContactsAddEvent(
                                    email: _emailController.text,
                                    phone_number: _phoneController.text,
                                    position: _positionController.text,
                                    name: _userInfoController.text,
                                    type: selectedIndex,
                                    avatar: avatar != null ? avatar : null,
                                  ));
                                }
                              }
                            },
                            title: widget.fromEdit ? "save" : 'add',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        ),
      ),
    );
  }
}
