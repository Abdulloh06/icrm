/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_state.dart';
import 'package:icrm/features/presentation/blocs/project_statuses_bloc/project_statuses_bloc.dart';
import 'package:icrm/features/presentation/blocs/project_statuses_bloc/project_statuses_state.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:icrm/features/presentation/pages/add_project/components/reminder_calendar.dart';
import 'package:icrm/features/presentation/pages/add_project/local_pages/company_add.dart';
import 'package:icrm/features/presentation/pages/add_project/components/user_categories.dart';
import 'package:icrm/features/presentation/pages/add_project/local_pages/contact_person.dart';
import 'package:icrm/features/presentation/pages/widgets/double_buttons.dart';
import 'package:icrm/widgets/custom_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../../core/models/team_model.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../blocs/helper_bloc/helper_event.dart';
import '../../main/main_page.dart';
import '../components/add_members.dart';

class Projects extends StatefulWidget {
  Projects({
    Key? key,
  }) : super(key: key);
  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final _formKey = GlobalKey<FormState>();
  final _speech = SpeechToText();

  bool isListening = false;
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _personInfoController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _currencyController = TextEditingController();
  final _dateController = TextEditingController();

  static String name = '';
  static int? user_category_id;
  static int? contact_id;
  static int? project_status_category;
  static int? company_id;
  static List<TeamModel> members = [];

  static String status = '';
  static String notify_at = '';

  void chooseUserCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.only(top: 60, bottom: 60),
          content: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width - 80,
            child: UserCategories(),
          ),
        );
      },
    );
  }

  void listen() async {
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (value) => print(value),
        onError: (error) => print('Error: $error'),
        debugLogging: true,
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        _speech.listen(
          onResult: (value) => setState(() {
            print(value.recognizedWords + " Words");
            _descriptionController.text = value.recognizedWords;
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectsBloc, ProjectsState>(
      listener: (context, state) {
        if (state is ProjectsNameState) {
          name = state.contact_name;
          _personInfoController.text = name;
          contact_id = state.contact_id;
          print(contact_id);
        }
        if (state is ProjectsCompanyState) {
          _companyNameController.text = state.name;
          company_id = state.company_id;
        }
        if (state is ProjectsUserCategoryState) {
          user_category_id = state.id;
          _categoryController.text = state.name;
        }
        if (state is ProjectsAddStatusState) {
          project_status_category = state.id;
          status = state.name;
        }

        if (state is ProjectsAddSuccessState) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
        }

        if (state is ProjectsErrorState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(20),
              backgroundColor: AppColors.red,
              content: LocaleText('something_went_wrong',
                  style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
            ),
          );
          context.read<ProjectsBloc>().add(ProjectsInitEvent());
        }
      },
      child: Container(
        color: UserToken.isDark ? AppColors.mainDark : Colors.white,
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: BlocBuilder<ProjectsBloc, ProjectsState>(
              builder: (context, state) {
            if (state is ProjectsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      BlocConsumer<HelperBloc, HelperState>(
                        listener: (context, state) {
                          if (state is HelperProjectMemberState) {
                            members.add(state.member);
                            context.read<HelperBloc>().add(HelperInitEvent());
                          }
                          if (state is HelperProjectDateState) {
                            notify_at = state.deadline;
                            _dateController.text = state.deadline;
                          }
                        },
                        builder: (context, state) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  validator: (value) => value!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                                  controller: _projectNameController,
                                  onChanged: (value) {},
                                  hint: 'project_name',
                                  isFilled: true,
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  validator: (value) => null,
                                  controller: _personInfoController,
                                  onChanged: (value) {},
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPerson())),
                                  hint: 'the_contact_person',
                                  readOnly: true,
                                  isFilled: true,
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ContactCompany(
                                        contact_id: contact_id,
                                      ),
                                    ),
                                  ),
                                  validator: (value) => null,
                                  controller: _companyNameController,
                                  onChanged: (value) {},
                                  hint: 'company',
                                  readOnly: true,
                                  isFilled: true,
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 55,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          validator: (value) => null,
                                          controller: TextEditingController(),
                                          suffixIcon: 'assets/icons_svg/add.svg',
                                          onChanged: (value) {},
                                          onTap: () {
                                            showDialog(context: context, builder: (context) {
                                              return AddMembers(id: 2);
                                            });
                                          },
                                          hint: 'appoint',
                                          readOnly: true,
                                          isFilled: true,
                                          color: UserToken.isDark
                                              ? AppColors.textFieldColorDark
                                              : AppColors.textFieldColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: members.length,
                                          itemBuilder: (context, index) {
                                            return CachedNetworkImage(
                                              imageUrl:
                                              members[index].social_avatar,
                                              errorWidget:
                                                  (context, error, bt) {
                                                return CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/png/no_user.png'),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ReminderCalendar(
                                          id: 2,
                                          isProject: true,
                                        );
                                      },
                                    );
                                  },
                                  readOnly: true,
                                  validator: (value) => null,
                                  controller: _dateController,
                                  onChanged: (value) {},
                                  hint: 'reminder_date',
                                  iconMargin: 15,
                                  suffixIcon: 'assets/icons_svg/cal.svg',
                                  isFilled: true,
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  onTap: () => chooseUserCategory(context),
                                  validator: (value) => null,
                                  controller: _categoryController,
                                  onChanged: (value) {},
                                  hint: 'project_category',
                                  readOnly: true,
                                  iconMargin: 15,
                                  isFilled: true,
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 55,
                                  child: BlocBuilder<ProjectStatusBloc, ProjectStatusState>(
                                    builder: (context, state) {
                                      if(state is ProjectStatusInitState &&
                                          state.projectStatuses.isNotEmpty) {
                                        project_status_category = state.projectStatuses.first.id;
                                      }
                                      return PopupMenuButton(
                                        offset: Offset(
                                          MediaQuery.of(context).size.width / 2,
                                          0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                        color: Colors.transparent,
                                        itemBuilder: (BuildContext context) {
                                          if (state is ProjectStatusInitState &&
                                              state.projectStatuses.isNotEmpty) {
                                            return List.generate(
                                              state.projectStatuses.length,
                                                  (index) {
                                                return PopupMenuItem(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  onTap: () {
                                                    context.read<ProjectsBloc>().add(
                                                      ProjectsAddStatusEvent(
                                                        id: state.projectStatuses[index].id,
                                                        name: state.projectStatuses[index].name,
                                                      ),
                                                    );
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Color(int.parse(state.projectStatuses[index]
                                                            .color
                                                            .split('#')
                                                            .join('0xff'))),
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                    child: Text(
                                                      state.projectStatuses[index].name,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            return [
                                              PopupMenuItem(
                                                child: LocaleText('empty'),
                                              ),
                                            ];
                                          }
                                        },
                                        child: Container(
                                          height: 48,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: UserToken.isDark
                                                ? AppColors.textFieldColorDark
                                                : AppColors.textFieldColor,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.greyLight),
                                          ),
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                status == ''
                                                    ? Locales.string(
                                                    context, 'project_status')
                                                    : status,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: status == ''
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),
                                              SvgPicture.asset(
                                                  'assets/icons_svg/plus.svg'),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  validator: (value) => null,
                                  controller: _descriptionController,
                                  onChanged: (value) {},
                                  hint: 'description',
                                  maxLines: 4,
                                  onIconTap: () => listen(),
                                  suffixIcon: 'assets/icons_svg/microphone.svg',
                                  iconMargin: 20,
                                  isFilled: true,
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 55,
                                        child: CustomTextField(
                                          validator: (value) => null,
                                          controller: _amountController,
                                          onChanged: (value) {},
                                          keyboardType: TextInputType.number,
                                          hint: 'summa',
                                          isFilled: true,
                                          color: UserToken.isDark
                                              ? AppColors.textFieldColorDark
                                              : AppColors.textFieldColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        height: 55,
                                        child: CustomTextField(
                                          validator: (value) => null,
                                          controller: _currencyController,
                                          onChanged: (value) {},
                                          hint: 'sum',
                                          isFilled: true,
                                          readOnly: true,
                                          color: UserToken.isDark
                                              ? AppColors.textFieldColorDark
                                              : AppColors.textFieldColor,
                                          onTap: () {
                                            showCurrencyPicker(
                                              context: context,
                                              showFlag: true,
                                              showCurrencyName: true,
                                              showCurrencyCode: true,
                                              onSelect: (Currency currency) {
                                                _currencyController.text =
                                                    currency.code;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 15),
                      DoubleButtons(
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onSave: () {
                          List<int> users = [];
                          for (int i = 0; i < members.length; i++) {
                            users.add(members[i].id);
                          }
                          if(_formKey.currentState!.validate()) {
                            context.read<ProjectsBloc>().add(ProjectsAddEvent(
                              name: _projectNameController.text,
                              description: _descriptionController.text,
                              user_category_id: user_category_id,
                              project_status_id: project_status_category!,
                              notify_at: notify_at != "" ? DateFormat("dd.MM.yyyy").parse(notify_at).toString() : notify_at,
                              currency: _currencyController.text,
                              is_owner: true,
                              price: _amountController.text,
                              company_id: company_id,
                              members: users,
                            ));
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
