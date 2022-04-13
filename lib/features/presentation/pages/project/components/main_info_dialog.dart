import 'dart:io';
import 'package:icrm/core/models/contacts_model.dart';
import 'package:icrm/features/presentation/blocs/company_bloc/company_bloc.dart';
import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_event.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/main_button.dart';

//ignore:must_be_immutable
class MainInfoDialog extends StatefulWidget {
  MainInfoDialog({
    Key? key,
    required this.projectName,
    required this.companyName,
    required this.company_id,
    required this.logo,
    required this.contact_id,
    required this.contactName,
    required this.contact,
    required this.url,
    required this.projectId,
  }) : super(key: key);

  final dynamic contact_id;
  final ContactModel? contact;
  final String projectName;
  final String contactName;
  final String companyName;
  final String url;
  String logo;
  final int company_id;
  final int projectId;

  @override
  State<MainInfoDialog> createState() => _MainInfoDialogState();
}

class _MainInfoDialogState extends State<MainInfoDialog> {
  final projectNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final contactName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  File? logo;

  void pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          logo = File(image.path);
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    projectNameController.text = widget.projectName;
    companyNameController.text = widget.companyName;
    if (widget.contact != null) {
      contactName.text = widget.contact!.name;
      phoneController.text = widget.contact!.phone_number;
      emailController.text = widget.contact!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        Locales.string(context, 'change_project_info'),
        textAlign: TextAlign.center,
        style: AppTextStyles.mainBold.copyWith(fontSize: 20),
      ),
      insetPadding: const EdgeInsets.only(top: 60, bottom: 100),
      content: Column(
        children: [
          GestureDetector(
            onTap: () => pickImage(),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Builder(
                  builder: (context) {
                    if (logo != null) {
                      return Image.file(File(logo!.path));
                    } else {
                      return CachedNetworkImage(
                        imageUrl: widget.logo,
                        placeholder: (context, stack) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainColor,
                            ),
                          );
                        },
                        errorWidget: (context, error, stack) {
                          return Image.asset('assets/png/default_logo.png');
                        },
                      );
                    }
                  },
                ),
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
                    validator: (val) => null,
                    hint: 'company',
                    controller: companyNameController,
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
                    hint: 'project_name',
                    controller: projectNameController,
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
                    hint: 'the_contact_person',
                    controller: contactName,
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
                    hint: 'number_phone',
                    controller: phoneController,
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
                    hint: 'email',
                    controller: emailController,
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(height: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                const SizedBox(
                  width: 30,
                ),
                MainButton(
                  fontSize: 15,
                  color: AppColors.mainColor,
                  title: 'done',
                  onTap: () {
                    if (logo != null) {
                      context.read<CompanyBloc>().add(
                        CompanyUpdateEvent(
                          id: widget.company_id,
                          logo: logo!,
                          description: 'description',
                          name: companyNameController.text,
                          contact_id: widget.contact_id == null
                              ? widget.contact!.id
                              : widget.contact_id,
                          url: widget.url,
                          hasLogo: true
                        ),
                      );
                    }else {
                      if(widget.contactName != companyNameController.text) {
                        context.read<CompanyBloc>().add(CompanyUpdateEvent(
                          id: widget.company_id,
                          logo: File(''),
                          description: 'description',
                          name: companyNameController.text,
                          contact_id: widget.contact_id == null
                              ? widget.contact!.id
                              : widget.contact_id,
                          url: widget.url,
                          hasLogo: false,
                        ),);
                      }
                    }
                    context.read<ContactsBloc>().add(
                      ContactsUpdateEvent(
                        id: widget.contact_id == null
                            ? widget.contact!.id
                            : widget.contact_id,
                        email: emailController.text,
                        phone_number: phoneController.text,
                        position: widget.contact!.position,
                        name: contactName.text,
                        type: widget.contact!.contact_type,
                        hasAvatar: false,
                      ),
                    );
                    context.read<ProjectsBloc>().add(ProjectsShowEvent(id: widget.projectId));
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
