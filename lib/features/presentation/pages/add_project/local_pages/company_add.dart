/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/company_bloc/company_bloc.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_event.dart';
import 'package:icrm/features/presentation/pages/drawer/companies/components/company_card.dart';
import 'package:icrm/features/presentation/pages/widgets/one_button.dart';
import 'package:icrm/widgets/custom_text_field.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/models/company_model.dart';

class ContactCompany extends StatefulWidget {
  ContactCompany({
    Key? key,
    required this.contact_id,
    required this.company_id,
  }) : super(key: key) {
    print(contact_id);
  }

  final int? contact_id;
  final int? company_id;

  @override
  State<ContactCompany> createState() => _ContactCompanyState();
}

class _ContactCompanyState extends State<ContactCompany> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageController = TextEditingController();
  String imageUrl = '';
  XFile? logo;
  bool hasImage = false;

  void pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        _imageController.text = image.path.split('/').last;
        setState(() {
          logo = image;
          hasImage = true;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<CompanyBloc>().add(CompanyInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      appBar: AppBar(
        backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              const Icon(Icons.arrow_back_ios),
              LocaleText(
                'back',
                style: AppTextStyles.mainBold,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<CompanyBloc, CompanyState>(
          listener: (context, state) {
            if(state is CompanyAddState) {
              context.read<HelperBloc>().add(HelperProjectMainEvent(
                name: state.company.name,
                id: state.company.id,
                type: 2,
              ));
              Navigator.pop(context);
            }
            if(state is CompanyErrorState) {
              context.read<CompanyBloc>().add(CompanyInitEvent());
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
          builder: (context, state) {
            if(state is CompanyInitState) {
              if(widget.company_id != null) {
                CompanyModel company = state.companies.elementAt(state.companies.indexWhere(
                      (element) => element.id == widget.company_id!,
                ));

                _nameController.text = company.name;
                _imageController.text = company.logo.split('//').last;
                _urlController.text = company.site_url;
                imageUrl = company.logo;
              }
            }
            if(state is CompanyLoadingState) {
              return Loading();
            }else {
              return Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        validator: (value) => value!.isEmpty
                            ? Locales.string(context, "must_fill_this_line")
                            : null,
                        controller: _nameController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        hint: 'company_name',
                        isFilled: true,
                        color: UserToken.isDark
                            ? AppColors.textFieldColorDark
                            : AppColors.textFieldColor,
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: _nameController.text.isNotEmpty,
                        child: Builder(
                          builder: (context) {
                            if(state is CompanyInitState) {
                              return Visibility(
                                visible: _nameController.text != '' && state.companies.any((element) => element.name.toLowerCase().contains(_nameController.text.toLowerCase())),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  child: ListView.builder(
                                    itemCount: state.companies.length,
                                    itemBuilder: (context, index) {
                                      return Visibility(
                                        visible: state.companies[index].name.toLowerCase().contains(_nameController.text.toLowerCase()),
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: CompanyCard(
                                            onTap: () {
                                              context.read<HelperBloc>().add(
                                                HelperProjectMainEvent(
                                                  name: state.companies[index].name,
                                                  id: state.companies[index].id,
                                                  type: 2,
                                                ),
                                              );
                                              Navigator.pop(context);
                                            },
                                            direction: state.companies[index].description,
                                            name: state.companies[index].name.toString(),
                                            image: state.companies[index].logo,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      CustomTextField(
                        onTap: () => pickImage(),
                        validator: (value) => null,
                        controller: _imageController,
                        onChanged: (value) {},
                        readOnly: true,
                        suffixIcon: 'assets/icons_svg/plus.svg',
                        iconMargin: 15,
                        hint: 'logo',
                        isFilled: true,
                        color: UserToken.isDark
                            ? AppColors.textFieldColorDark
                            : AppColors.textFieldColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                      Builder(
                        builder: (context) {
                          if(widget.company_id == null) {
                            if(hasImage) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Image.file(
                                  File(logo!.path),
                                ),
                              );
                            }else {
                              return SizedBox.shrink();
                            }
                          }else {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                placeholder: (context, process) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.mainColor,
                                    ),
                                  );
                                },
                                errorWidget: (context, error, stack) {
                                  return Image.asset(
                                    "assets/png/default_logo.png",
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      OneButtonWidget(
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            if(widget.contact_id != null) {
                              context.read<CompanyBloc>().add(CompanyAddEvent(
                                contactId: widget.contact_id,
                                image: logo != null ? File(logo!.path) : null,
                                url: _urlController.text,
                                name: _nameController.text,
                                description: 'description',
                              ));
                            }else {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(20),
                                  backgroundColor: AppColors.mainColor,
                                  content: LocaleText("first_fill_contact_info", style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
