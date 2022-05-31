import 'package:icrm/features/presentation/blocs/contacts_bloc/contacts_event.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../../../core/models/contacts_model.dart';
import '../../../../../../core/repository/user_token.dart';
import '../../../../../../core/util/colors.dart';
import '../../../../../../core/util/text_styles.dart';
import '../../../../../../widgets/custom_text_field.dart';
import '../../../../../../widgets/loading.dart';
import '../../../../../../widgets/main_person_contact.dart';
import '../../../../blocs/contacts_bloc/contacts_bloc.dart';
import '../../../../blocs/contacts_bloc/contacts_state.dart';
import '../../../widgets/one_button.dart';

class AddContactCompany extends StatelessWidget {
  AddContactCompany({
    Key? key,
    this.fromEdit = false,
    this.contact,
  }) : super(key: key);

  final bool fromEdit;
  final ContactModel? contact;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void initState() {
    if(contact != null) {
      _nameController.text = contact!.name;
      _emailController.text = contact!.email;
      _phoneController.text = contact!.phone_number;
    }
  }

  @override
  Widget build(BuildContext context) {
    initState();
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
              if(state is ContactsAddFromProjectState) {
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
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
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
                            Visibility(
                              visible: _nameController.text.isNotEmpty && !fromEdit,
                              child: BlocBuilder<ContactsBloc, ContactsState>(
                                builder: (context, state) {
                                  if (state is ContactsInitState) {
                                    return Visibility(
                                      visible: state.contacts.any((element) =>
                                          element.name.toLowerCase().contains(
                                              _nameController.text.toLowerCase())) && _nameController.text.isNotEmpty,
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        child: ListView.builder(
                                          itemCount: state.contacts.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                              const EdgeInsets.only(bottom: 10),
                                              child: Visibility(
                                                visible: state.contacts[index].name.toLowerCase().contains(_nameController.text.toLowerCase()),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context.read<HelperBloc>().add(HelperCompanyContactEvent(contact: state.contacts[index]));
                                                    Navigator.pop(context);
                                                  },
                                                  child: MainPersonContact(
                                                    name: state.contacts[index].name,
                                                    phone_number: state.contacts[index].phone_number,
                                                    response: state.contacts[index].position,
                                                    photo: state.contacts[index].avatar,
                                                    email: state.contacts[index].email,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    context.read<ContactsBloc>().add(ContactsInitEvent());
                                    return Loading();
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      validator: (value) => value!.isEmpty
                          ? null
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
                    SizedBox(height: 20),
                    CustomTextField(
                      validator: (value) => null,
                      controller: _emailController,
                      onChanged: (value) {},
                      hint: 'email',
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : AppColors.textFieldColor,
                    ),
                    const SizedBox(height: 51),
                    OneButtonWidget(
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          if(fromEdit) {
                            context.read<ContactsBloc>().add(
                              ContactsUpdateEvent(
                                id: contact!.id,
                                email: _emailController.text,
                                phone_number: _phoneController.text,
                                position: '',
                                name: _nameController.text,
                                type: 1,
                              ),
                            );
                          } else {
                            context.read<ContactsBloc>().add(
                              ContactsAddFromProject(
                                email: _emailController.text,
                                phone_number: _phoneController.text,
                                position: '',
                                name: _nameController.text,
                                type: 1,
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
