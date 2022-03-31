import 'dart:io';
import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/company_bloc/company_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:avlo/features/presentation/pages/drawer/companies/components/company_card.dart';
import 'package:avlo/features/presentation/pages/widgets/one_button.dart';
import 'package:avlo/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:image_picker/image_picker.dart';
import '../../../blocs/projects_bloc/projects_event.dart';

class ContactCompany extends StatefulWidget {
  ContactCompany({
    Key? key,
    required this.contact_id,
  }) : super(key: key) {
    print(contact_id);
  }

  final int? contact_id;

  @override
  State<ContactCompany> createState() => _ContactCompanyState();
}

class _ContactCompanyState extends State<ContactCompany> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageController = TextEditingController();
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
              context.read<ProjectsBloc>().add(ProjectsCompanyEvent(
                company_id: state.company.id,
                name: state.company.name,
              ));
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
          builder: (context, state) {
            if(state is CompanyLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              );
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
                                              context.read<ProjectsBloc>().add(ProjectsCompanyEvent(
                                                company_id: state.companies[index].id,
                                                name: state.companies[index].name,
                                              ));
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
                        validator: (value) =>
                        hasImage ? null : Locales.string(context, 'key'),
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
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        validator: (value) => value!.isEmpty
                            ? Locales.string(context, "must_fill_this_line")
                            : null,
                        controller: _urlController,
                        onChanged: (value) {},
                        hint: 'company_url',
                        isFilled: true,
                        color: UserToken.isDark
                            ? AppColors.textFieldColorDark
                            : AppColors.textFieldColor,
                      ),
                      const SizedBox(height: 20),
                      if (hasImage) SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Image.file(
                          File(logo!.path),
                        ),
                      ) else SizedBox.shrink(),
                      const SizedBox(height: 20),
                      OneButtonWidget(
                        press: () {
                          if(widget.contact_id != null) {
                            if (_formKey.currentState!.validate()) {
                              context.read<CompanyBloc>().add(CompanyAddEvent(
                                contactId: widget.contact_id!,
                                image: File(logo!.path),
                                url: _urlController.text,
                                name: _nameController.text,
                                description: 'description',
                              ));
                            }
                          }else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.all(20),
                                backgroundColor: AppColors.mainColor,
                                content: LocaleText('first_fill_contact_info', style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
                              ),
                            );
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
