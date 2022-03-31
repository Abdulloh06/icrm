import 'package:avlo/core/models/contacts_model.dart';
import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_event.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_state.dart';
import 'package:avlo/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:avlo/features/presentation/blocs/helper_bloc/helper_event.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:avlo/features/presentation/pages/widgets/one_button.dart';
import 'package:avlo/widgets/custom_text_field.dart';
import 'package:avlo/widgets/main_person_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPerson extends StatefulWidget {
  ContactPerson({
    Key? key,
    this.fromProject = true,
  }) : super(key: key);
  
  final bool fromProject;

  @override
  State<ContactPerson> createState() => _ContactPersonState();
}

class _ContactPersonState extends State<ContactPerson> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _phoneController = TextEditingController();

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
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: BlocListener<ContactsBloc, ContactsState>(
            listener: (context, state) {
              if (state is ContactsAddFromProjectState) {
                if(widget.fromProject) {
                  context.read<ProjectsBloc>().add(
                      ProjectsNameEvent(contact_id: state.id, name: state.name));
                }else {
                  context.read<HelperBloc>().add(HelperLeadContactEvent(name: state.name, id: state.id));
                }
                Navigator.pop(context);
                context.read<ContactsBloc>().add(ContactsInitEvent());
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
            child: Container(
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
                          ? Locales.string(context, 'must_fill_this_line')
                          : null,
                      controller: _nameController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      hint: 'name',
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                    ),
                    BlocBuilder<ContactsBloc, ContactsState>(
                      builder: (context, state) {
                        if (state is ContactsInitState) {
                          List<ContactModel> contacts = state.contacts
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(_nameController.text.toLowerCase()))
                              .toList();
                          return Visibility(
                            visible: state.contacts.any((element) =>
                                element.name.toLowerCase().contains(
                                    _nameController.text.toLowerCase())) && _nameController.text.isNotEmpty,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: ListView.builder(
                                itemCount: contacts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        if(widget.fromProject) {
                                          context.read<ProjectsBloc>().add(
                                            ProjectsNameEvent(
                                              contact_id:
                                              contacts[index].id,
                                              name: contacts[index].name,
                                            ),
                                          );
                                        }else {
                                          context.read<HelperBloc>().add(HelperLeadContactEvent(name: contacts[index].name, id: contacts[index].id));
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: MainPersonContact(
                                        name: contacts[index].name,
                                        phone_number:
                                            contacts[index].phone_number,
                                        response: contacts[index].position,
                                        photo: 'assets/png/no_user.png',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainColor,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      validator: (value) => value!.isEmpty
                          ? Locales.string(context, 'must_fill_this_line')
                          : null,
                      controller: _positionController,
                      onChanged: (value) {},
                      hint: 'position',
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      validator: (value) => value!.isEmpty
                          ? Locales.string(context, 'must_fill_this_line')
                          : value.length < 6
                              ? Locales.string(context, 'enter_valid_info')
                              : null,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {},
                      hint: 'number_phone',
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
                          ? Locales.string(context, 'must_fill_this_line')
                          : value.contains('@') && value.length > 4
                              ? null
                              : Locales.string(context, 'enter_valid_info'),
                      controller: _emailController,
                      onChanged: (value) {},
                      hint: 'email',
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                    ),
                    const SizedBox(height: 71),
                    OneButtonWidget(
                      press: () {
                        if (_formKey.currentState!.validate()) {
                            if(widget.fromProject) {
                              context.read<ContactsBloc>().add(
                                ContactsAddFromProject(
                                  email: _emailController.text,
                                  phone_number: _phoneController.text,
                                  position: _positionController.text,
                                  name: _nameController.text,
                                  type: 2,
                                  source: 1,
                                ),
                              );
                            }else {
                              context.read<ContactsBloc>().add(
                                ContactsAddFromProject(
                                  email: _emailController.text,
                                  phone_number: _phoneController.text,
                                  position: _positionController.text,
                                  name: _nameController.text,
                                  type: 2,
                                  source: 2,
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
    );
  }
}