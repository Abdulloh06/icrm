/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/features/presentation/blocs/company_bloc/company_bloc.dart';
import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_state.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_state.dart';
import 'package:icrm/features/presentation/pages/drawer/companies/pages/add_contact.dart';
import 'package:icrm/features/presentation/pages/widgets/one_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/models/company_model.dart';
import '../../../../../../core/repository/user_token.dart';
import '../../../../../../core/util/colors.dart';
import '../../../../../../core/util/text_styles.dart';
import '../../../../../../widgets/custom_text_field.dart';
import '../../../../../../widgets/main_app_bar.dart';

class AddCompany extends StatefulWidget {
  AddCompany({
    Key? key,
    this.fromEdit = false,
    this.company,
  }) : super(key: key);

  final bool fromEdit;
  final CompanyModel? company;

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final _companyNameController = TextEditingController();
  final _urlController = TextEditingController();
  final _contactPersonController = TextEditingController();
  int? contactId;
  String logoUrl = '';

  final _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

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
  File? logo;

  @override
  void initState() {
    super.initState();
    if(widget.fromEdit) {
      _companyNameController.text = widget.company!.name;
      _urlController.text = widget.company!.site_url;
      logoUrl = widget.company!.logo;
      _contactPersonController.text = widget.company!.contact!.name;
      contactId = widget.company!.contact_id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'add_company',
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: BlocListener<HelperBloc, HelperState>(
            listener: (context, state) {
              if(state is HelperCompanyContactState) {
                print(state.contact.name);
                contactId = state.contact.id;
                _contactPersonController.text = state.contact.name;
              }
            },
            child: BlocListener<ContactsBloc, ContactsState>(
              listener: (context, state) {
                if (state is ContactsAddFromProjectState) {
                  contactId = state.id;
                  _contactPersonController.text = state.name;
                }
              },
              child: BlocListener<CompanyBloc, CompanyState>(
                listener: (context, state) {
                  if(state is CompanyAddState) {
                    context.read<CompanyBloc>().add(CompanyInitEvent());
                    Navigator.pop(context);
                  }
                  if(state is CompanyShowState) {
                    context.read<CompanyBloc>().add(CompanyInitEvent());
                    Navigator.pop(context);
                  }
                  if(state is CompanyErrorState) {
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => pickImage(),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: ClipOval(
                              child: Builder(
                                builder: (context) {
                                  if (logo != null) {
                                    return Image.file(
                                      File(logo!.path),
                                      fit: BoxFit.fill,
                                    );
                                  } else {
                                    if (logoUrl.isNotEmpty) {
                                      return CachedNetworkImage(
                                        imageUrl: logoUrl,
                                        fit: BoxFit.fill,
                                        placeholder: (context, stack) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.mainColor,
                                            ),
                                          );
                                        },
                                        errorWidget: (context, error, stack) {
                                          return Image.asset(
                                            'assets/png/default_logo.png',
                                            fit: BoxFit.fill,
                                          );
                                        },
                                      );
                                    } else {
                                      return Image.asset(
                                        'assets/png/default_logo.png',
                                        fit: BoxFit.fill,
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hint: 'company_name',
                              validator: (value) => value!.isEmpty
                                  ? Locales.string(context, "must_fill_this_line")
                                  : null,
                              controller: _companyNameController,
                              onChanged: (value) => null,
                              isFilled: true,
                              color: UserToken.isDark
                                  ? AppColors.textFieldColorDark
                                  : AppColors.textFieldColor,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              validator: (value) => null,
                              controller: _urlController,
                              onChanged: (value) {},
                              hint: 'company_url',
                              isFilled: true,
                              color: UserToken.isDark
                                  ? AppColors.textFieldColorDark
                                  : AppColors.textFieldColor,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddContactCompany(
                                      fromEdit: widget.fromEdit,
                                      contact: widget.fromEdit ? widget.company!.contact : null,
                                    ),
                                  ),
                                );
                              },
                              validator: (value) => null,
                              controller: _contactPersonController,
                              onChanged: (value) {},
                              readOnly: true,
                              hint: 'the_contact_person',
                              isFilled: true,
                              color: UserToken.isDark
                                  ? AppColors.textFieldColorDark
                                  : AppColors.textFieldColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      OneButtonWidget(
                        press: () {
                          print(contactId);
                          if(contactId != null) {
                            if(widget.fromEdit) {
                              context.read<CompanyBloc>().add(CompanyUpdateEvent(
                                id: widget.company!.id,
                                name: _companyNameController.text,
                                url: _urlController.text,
                                logo: logo,
                                contact_id: widget.company!.contact_id,
                                description: "description",
                              ));
                            }else {
                              context.read<CompanyBloc>().add(
                                CompanyAddEvent(
                                  contactId: contactId,
                                  image: logo,
                                  url: _urlController.text,
                                  name: _companyNameController.text,
                                  description: 'description',
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
