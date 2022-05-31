/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:avatar_glow/avatar_glow.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_input_format.dart';
import 'package:icrm/features/presentation/blocs/cubits/bottom_bar_cubit.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_event.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_state.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:icrm/features/presentation/blocs/search_bloc/search_event.dart';
import 'package:icrm/features/presentation/blocs/search_bloc/search_state.dart';
import 'package:icrm/features/presentation/pages/add_project/components/add_members.dart';
import 'package:icrm/features/presentation/pages/add_project/local_pages/contact_person.dart';
import 'package:icrm/features/presentation/pages/widgets/double_buttons.dart';
import 'package:icrm/widgets/custom_text_field.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../../../core/models/leads_model.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../blocs/home_bloc/home_event.dart';
import '../../../blocs/search_bloc/search_bloc.dart';
import '../../main/main_page.dart';
import '../components/reminder_calendar.dart';

class Leads extends StatefulWidget {
  Leads({
    Key? key,
    this.fromEdit = false,
    this.lead,
    this.name,
  }) : super(key: key);

  final bool fromEdit;
  final LeadsModel? lead;
  final String? name;

  @override
  State<Leads> createState() => _LeadsState();
}

class _LeadsState extends State<Leads> {
  String start_date = '';
  String deadline = '';
  String status = '';
  int? status_id;
  int? project_id;
  int? contact_id;
  List<TeamModel> members = [];

  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _currencyController = TextEditingController();
  final _searchController = TextEditingController();
  final _projectController = TextEditingController();
  final _dateController = TextEditingController();
  final _personInfoController = TextEditingController();

  bool isListening = false;
  final _speech = SpeechToText();

  void showProjects(BuildContext context) {
    context.read<SearchBloc>().add(SearchProjectEvent());
    showDialog(
      context: context,
      builder: (context) {
        return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: AlertDialog(
              backgroundColor:
                  UserToken.isDark ? AppColors.mainDark : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(vertical: 60),
              content: SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    CustomTextField(
                      suffixIcon: 'assets/icons_svg/search.svg',
                      iconMargin: 15,
                      iconColor: AppColors.greyDark,
                      hint: 'search',
                      controller: _searchController,
                      onChanged: (value) {},
                      validator: (value) => null,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      isFilled: true,
                      color: UserToken.isDark ? AppColors.textFieldColorDark : Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          if (state is SearchProjectsState && state.projects.isNotEmpty) {
                            return ListView.builder(
                              itemCount: state.projects.length,
                              itemBuilder: (context, index) {
                                return Visibility(
                                  visible: state.projects[index].name
                                      .toLowerCase()
                                      .contains(
                                          _searchController.text.toLowerCase()),
                                  child: GestureDetector(
                                    onTap: () {
                                      _projectController.text =
                                          state.projects[index].name;
                                      project_id = state.projects[index].id;
                                      _currencyController.text = state.projects[index].currency;
                                      if(state.projects[index].price != null) {
                                        _amountController.text = state.projects[index].price.toString();
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: UserToken.isDark
                                            ? AppColors.mainDark
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              state.projects[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles.proText
                                                  .copyWith(
                                                color: !UserToken.isDark
                                                    ? AppColors.mainColor
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                          SvgPicture.asset(
                                              "assets/icons_svg/vect.svg"),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (state is SearchProjectsState &&
                              state.projects.isEmpty) {
                            return Center(
                              child: LocaleText('empty',
                                  style: AppTextStyles.mainGrey),
                            );
                          } else if (state is SearchErrorState) {
                            return Center(
                              child: Text(state.error),
                            );
                          } else {
                            return Loading();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
      }else {
        setState(() {
          isListening != false;
        });
        _speech.stop();
      }
    } else {
      setState(() {
        isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    members.clear();

    if (widget.fromEdit) {
      if(widget.name != null) {
        _projectController.text = widget.name!;
      }else {
        _projectController.text = widget.lead!.project!.name;
      }
      _personInfoController.text = widget.lead!.contact != null ? widget.lead!.contact!.name : "";
      _descriptionController.text = widget.lead!.description;
      status = widget.lead!.leadStatus!.name;
      if(widget.lead!.member != null) {
        members.add(widget.lead!.member!);
      }
      if(widget.lead!.estimatedAmount != null) {
        _amountController.text = widget.lead!.estimatedAmount.toString();
      }
      if(widget.lead!.currency != null) {
        _currencyController.text = widget.lead!.currency;
      }

      project_id = widget.lead!.projectId;
      contact_id = widget.lead!.contactId;
      status_id = widget.lead!.leadStatusId;
      try {
        start_date = DateFormat("dd.MM.yyyy").format(DateTime.parse(widget.lead!.startDate)).toString();
        deadline = DateFormat("dd.MM.yyyy").format(DateTime.parse(widget.lead!.endDate)).toString();
        _dateController.text = start_date + " - " + deadline;
      } catch(error) {
        print(error);
        _dateController.text = widget.lead!.startDate + " - " + widget.lead!.endDate;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is LeadAddSuccessState) {
          context.read<BottomBarCubit>().changePage(0);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
        }
        if (state is HomeErrorState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(20),
              backgroundColor: AppColors.mainColor,
              content: LocaleText('something_went_wrong', style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
            ),
          );
          context.read<HomeBloc>().add(HomeInitEvent());
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if(state is HomeInitState) {
          if(state.leadStatus.isNotEmpty && status_id == null) {
            List<StatusModel> visibleStatuses = state.leadStatus.where((element) => element.userLabel != null).toList();
            if(visibleStatuses.isNotEmpty) {
              status = visibleStatuses.first.userLabel!.name;
              status_id = visibleStatuses.first.id;
            }
          }
        }
        if (state is HomeLoadingState) {
          return Loading();
        } else {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Container(
                color: UserToken.isDark ? AppColors.mainDark : Colors.white,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      BlocListener<HelperBloc, HelperState>(
                        listener: (context, state) {
                          if (state is HelperLeadMemberState) {
                            members.clear();
                            members.add(state.member);
                            context.read<HelperBloc>().add(HelperInitEvent());
                          }
                          if (state is HelperLeadDateState) {
                            start_date = state.start_date;
                            deadline = state.deadline;

                            _dateController.text =
                                state.start_date + " - " + state.deadline;
                            context.read<HelperBloc>().add(HelperInitEvent());
                          }
                          if(state is HelperLeadContactState) {
                            _personInfoController.text = state.name;
                            contact_id = state.id;
                            context.read<HelperBloc>().add(HelperInitEvent());
                          }
                        },
                        child: BlocBuilder<HelperBloc, HelperState>(
                            builder: (context, help) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  onTap: () => showProjects(context),
                                  validator: (value) => value!.isEmpty
                                      ? Locales.string(
                                          context, 'must_fill_this_line')
                                      : null,
                                  controller: _projectController,
                                  onChanged: (value) {},
                                  suffixIcon: 'assets/icons_svg/plus.svg',
                                  iconMargin: 15,
                                  readOnly: true,
                                  hint: 'project',
                                  isFilled: true,
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  validator: (value) => value!.isEmpty
                                      ? Locales.string(
                                          context, 'must_fill_this_line')
                                      : null,
                                  controller: _personInfoController,
                                  onChanged: (value) {},
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ContactPerson(
                                      fromProject: false,
                                      contact_id: contact_id,
                                    )),
                                  ),
                                  hint: 'the_contact_person',
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
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AddMembers(
                                                  id: 1,
                                                );
                                              },
                                            );
                                          },
                                          validator: (value) => null,
                                          controller: TextEditingController(),
                                          suffixIcon:
                                              'assets/icons_svg/add.svg',
                                          onChanged: (value) {},
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
                                            return CircleAvatar(
                                              radius: 25,
                                              child: SizedBox(
                                                height: double.infinity,
                                                width: double.infinity,
                                                child: ClipOval(
                                                  child: GestureDetector(
                                                    onLongPress: () {
                                                      members.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          members[index].social_avatar,
                                                      fit: BoxFit.fill,
                                                      errorWidget: (context, error, bt) {
                                                        return CircleAvatar(
                                                          backgroundImage: AssetImage(
                                                            'assets/png/no_user.png',
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                PopupMenuButton(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width / 2,
                                    0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  color: Colors.transparent,
                                  itemBuilder: (BuildContext context) {
                                    if (state is HomeInitState) {
                                      List<StatusModel> visibleStatuses = state.leadStatus.where((element) => element.userLabel != null).toList();
                                      return List.generate(
                                        visibleStatuses.length, (index) {
                                          String title = visibleStatuses[index].userLabel!.name;
                                          String color = visibleStatuses[index].userLabel!.color;

                                          return PopupMenuItem(
                                            padding:
                                            const EdgeInsets.only(
                                                right: 10),
                                            onTap: () {
                                              status = title;
                                              status_id = visibleStatuses[index].id;
                                              setState(() {});
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Container(
                                                alignment:
                                                Alignment.center,
                                                color: Color(
                                                  int.parse(color.split('#').join('0xff')),
                                                ),
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 20,
                                                    vertical: 8),
                                                child: Text(
                                                  title,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else if(state is LeadShowState) {
                                      List<StatusModel> visibleStatuses = state.leadStatus.where((element) => element.userLabel != null).toList();
                                      return List.generate(
                                        visibleStatuses.length,
                                            (index) {
                                          String title = visibleStatuses[index].name;
                                          String color = visibleStatuses[index].color;

                                          return PopupMenuItem(
                                            padding:
                                            const EdgeInsets.only(
                                                right: 10),
                                            onTap: () {
                                              status = visibleStatuses[index].name;
                                              status_id = visibleStatuses[index].id;
                                              setState(() {});
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              child: Container(
                                                alignment:
                                                Alignment.center,
                                                color: Color(
                                                  int.parse(color.split('#').join('0xff')),
                                                ),
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 8,
                                                ),
                                                child: Text(
                                                  title,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }else {
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
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 1,
                                          color: AppColors.greyLight),
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          status == '' ? Locales.string(context,
                                            'lead_status',
                                          ) : status,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: status == ''
                                                ? Colors.grey
                                                : UserToken.isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons_svg/plus.svg',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ReminderCalendar(
                                          id: 1,
                                        );
                                      },
                                    );
                                  },
                                  readOnly: true,
                                  validator: (value) => null,
                                  controller: _dateController,
                                  onChanged: (value) {},
                                  hint: 'start_date_end_date',
                                  iconMargin: 15,
                                  suffixIcon: 'assets/icons_svg/cal.svg',
                                  isFilled: true,
                                  color: UserToken.isDark
                                      ? AppColors.textFieldColorDark
                                      : AppColors.textFieldColor,
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  maxLines: 6,
                                  cursorColor: AppColors.mainColor,
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(bottom: 70),
                                      child: AvatarGlow(
                                        glowColor: AppColors.mainColor,
                                        endRadius: 40,
                                        animate: isListening,
                                        child: GestureDetector(
                                          onTap: () => listen(),
                                          child: CircleAvatar(
                                            child: SvgPicture.asset(
                                              "assets/icons_svg/microphone.svg",
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isDense: true,
                                    hintText: Locales.string(context, "description"),
                                    hintStyle: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: AppColors.greyLight),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.5, color: AppColors.mainColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fillColor: UserToken.isDark
                                        ? AppColors.textFieldColorDark
                                        : AppColors.textFieldColor,
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomTextField(
                                        validator: (value) => null,
                                        controller: _amountController,
                                        onChanged: (value) {},
                                        inputFormatters: [
                                          NumericTextFormatter(),
                                        ],
                                        keyboardType: TextInputType.number,
                                        hint: 'summa',
                                        isFilled: true,
                                        color: UserToken.isDark
                                            ? AppColors.textFieldColorDark
                                            : AppColors.textFieldColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CustomTextField(
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
                                        readOnly: true,
                                        validator: (value) => null,
                                        controller: _currencyController,
                                        onChanged: (value) {},
                                        hint: 'sum',
                                        isFilled: true,
                                        color: UserToken.isDark
                                            ? AppColors.textFieldColorDark
                                            : AppColors.textFieldColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 41),
                      DoubleButtons(
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onSave: () {
                          if (_formKey.currentState!.validate()) {
                            String start;
                            String end;
                            try {
                              start = start_date != '' ? DateFormat('dd.MM.yyyy').add_Hm().parse(start_date).toString() : start_date;
                              end = deadline != '' ? DateFormat('dd.MM.yyyy').add_Hm().parse(deadline).toString() : deadline;
                            } catch(_) {
                              start = start_date != '' ? DateFormat('dd.MM.yyyy').parse(start_date).toString() : start_date;
                              end = deadline != '' ? DateFormat('dd.MM.yyyy').parse(deadline).toString() : deadline;
                            }
                            if (widget.fromEdit) {
                              context.read<HomeBloc>().add(LeadsUpdateEvent(
                                id: widget.lead!.id,
                                project_id: project_id!,
                                contact_id: contact_id,
                                start_date: start,
                                end_date: end,
                                estimated_amount: _amountController.text,
                                lead_status: status_id!,
                                description: _descriptionController.text,
                                seller_id: members.isNotEmpty ? members.first.id : null,
                                currency: _currencyController.text,
                              ));
                              Navigator.pop(context);
                            } else {
                              context.read<HomeBloc>().add(
                                LeadsAddEvent(
                                  projectId: project_id!,
                                  contactId: contact_id,
                                  seller_id: members.isNotEmpty ? members.first.id : null,
                                  description: _descriptionController.text,
                                  estimated_amount: _amountController.text,
                                  startDate: start,
                                  endDate: end,
                                  leadStatus: status_id!,
                                  currency: _currencyController.text,
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
          );
        }
      }),
    );
  }
}
