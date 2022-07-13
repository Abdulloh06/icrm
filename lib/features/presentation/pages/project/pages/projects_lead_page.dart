/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/pages/leads/components/lead_card.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/main_button.dart';
import '../../../../../widgets/main_tab_bar.dart';
import '../../../blocs/projects_bloc/projects_state.dart';
import '../../leads/pages/leads_page.dart';

class ProjectLeadPage extends StatefulWidget {
  const ProjectLeadPage({
    Key? key,
    required this.leads,
    required this.project,
  }) : super(key: key);

  final List<LeadsModel> leads;
  final ProjectsModel project;

  @override
  State<ProjectLeadPage> createState() => _ProjectLeadPageState();
}

class _ProjectLeadPageState extends State<ProjectLeadPage> {

  bool isEdit = false;
  late List<LeadsModel> leads;

  List<String> colors = [
    "0xff2fa1ed",
    "0xffe80914",
    "0xffed2fa4",
    "0xff2fedc7",
    "0xff1b1bf2",
    "0xffe8881a",
  ];

  @override
  void initState() {
    super.initState();
    leads = widget.leads;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProjectsBloc, ProjectsState>(
      listener: (context, state) {
        if(state is ProjectsInitState) {
          leads = state.projects.elementAt(
            state.projects.indexWhere((element) => element.id == widget.project.id),
          ).leads ?? [];
          setState(() {});
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if(state is HomeInitState) {
            
            List<StatusModel> visibleStatuses = state.leadStatus.where(
                  (element) => element.userLabel != null,
            ).toList();
            List<StatusModel> invisibleStatus = state.leadStatus.where(
                  (element) => element.userLabel == null,
            ).toList();

            return DefaultTabController(
              length: visibleStatuses.length,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LocaleText(
                          'lead_status_name',
                          style: AppTextStyles.mainGrey,
                        ),
                        InkWell(
                          radius: 2,
                          borderRadius: BorderRadius.circular(20),
                          child: SvgPicture.asset('assets/icons_svg/edit.svg'),
                          onTap: () => setState(() {
                            isEdit = !isEdit;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 53,
                      child: Row(
                        children: [
                          Expanded(
                            child: MainTabBar(
                              isScrollable: visibleStatuses.length > 4,
                              labelPadding: visibleStatuses.length >= 4
                                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 0)
                                  : const EdgeInsets.all(0),
                              shadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color.fromARGB(40, 0, 0, 0),
                                ),
                              ],
                              tabs: List.generate(
                                  visibleStatuses.length,
                                      (index) {
                                    String title, color;
                                    if(visibleStatuses[index].userLabel != null) {
                                      title = visibleStatuses[index].userLabel!.name;
                                      color = visibleStatuses[index].userLabel!.color;
                                    }else {
                                      title = visibleStatuses[index].name;
                                      color = visibleStatuses[index].color;
                                    }
                                    return GestureDetector(
                                      onLongPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)),
                                              insetPadding: const EdgeInsets.symmetric(),
                                              title: Text(
                                                Locales.string(
                                                  context, 'you_want_delete_tab',
                                                ),
                                                textAlign: TextAlign.center,
                                                style: AppTextStyles.mainBold
                                                    .copyWith(fontSize: 22),
                                              ),
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                                  children: [
                                                    MainButton(
                                                      color: AppColors.red,
                                                      title: 'no',
                                                      onTap: () => Navigator.pop(context),
                                                      fontSize: 22,
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 50, vertical: 10,
                                                      ),
                                                    ),
                                                    MainButton(
                                                      onTap: () {
                                                        context.read<HomeBloc>().add(LeadStatusDeleteEvent(
                                                          id: visibleStatuses[index].id,
                                                        ));
                                                        Navigator.pop(context);
                                                      },
                                                      color: AppColors.mainColor,
                                                      title: 'yes',
                                                      fontSize: 22,
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 50, vertical: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: DragTarget<LeadCard>(
                                        onAccept: (object) {
                                          context.read<HomeBloc>().add(LeadsUpdateEvent(
                                            id: object.lead.id,
                                            project_id: object.lead.projectId,
                                            contact_id: object.lead.contactId ?? null,
                                            start_date: object.lead.startDate,
                                            end_date: object.lead.endDate,
                                            estimated_amount: object.lead.estimatedAmount,
                                            lead_status: visibleStatuses[index].id,
                                            seller_id: object.lead.seller_id,
                                            description: object.lead.description,
                                            currency: object.lead.currency,
                                          ));
                                          context.read<ProjectsBloc>().add(ProjectsInitEvent());
                                          setState(() {});
                                        },
                                        builder: (context, accept, reject) {
                                          return Visibility(
                                            replacement: Container(
                                              width: 70,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                ),
                                                initialValue: title,
                                                onChanged: (value) {
                                                  title = value;
                                                },
                                                onEditingComplete: () {
                                                  context.read<HomeBloc>().add(LeadsStatusUpdateEvent(
                                                    id: visibleStatuses[index].id,
                                                    name: title,
                                                    color: color,
                                                  ));
                                                  setState(() {
                                                    isEdit = !isEdit;
                                                  });
                                                },
                                              ),
                                            ),
                                            visible: !isEdit,
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                title,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Visibility(
                            visible: isEdit,
                            child: GestureDetector(
                              onTap: () {
                                String title = '';
                                String selectedColor = colors.first;
                                showDialog(context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      titlePadding: const EdgeInsets.all(20).copyWith(bottom: 5),
                                      title: Column(
                                        children: [
                                          TextField(
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: AppColors.greyLight,
                                                ),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: AppColors.mainColor,
                                                ),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              title = value;
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          StatefulBuilder(
                                              builder: (context, setState) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: List.generate(colors.length, (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedColor = colors[index];
                                                        });
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets.only(right: 2, left: 2),
                                                        decoration: BoxDecoration(
                                                          color: Color(int.parse(colors[index])),
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            width: 2,
                                                            color: selectedColor == colors[index] ? Colors.black : Colors.transparent,
                                                          ),
                                                        ),
                                                        height: 40,
                                                        width: 40,
                                                      ),
                                                    );
                                                  }),
                                                );
                                              }
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              MainButton(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 15,
                                                ),
                                                color: AppColors.red,
                                                title: 'cancel',
                                              ),
                                              MainButton(
                                                onTap: () {
                                                  if (title != '') {
                                                    if(invisibleStatus.isNotEmpty) {
                                                      context.read<HomeBloc>().add(
                                                        LeadsStatusUpdateEvent(
                                                          name: title,
                                                          id: invisibleStatus.first.id,
                                                          color: selectedColor,
                                                        ),
                                                      );
                                                      isEdit = !isEdit;
                                                    }else {
                                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          behavior: SnackBarBehavior.floating,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          margin: const EdgeInsets.all(20),
                                                          backgroundColor: AppColors.mainColor,
                                                          content: LocaleText("max_statuses_added", style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
                                                        ),
                                                      );
                                                    }
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                color: AppColors.green,
                                                title: 'save',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: SvgPicture.asset('assets/icons_svg/add_icon.svg',),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        children: List.generate(visibleStatuses.length, (index) {

                          List<LeadsModel> list = leads.where((element) =>
                            element.leadStatusId == visibleStatuses[index].id
                          ).toList();

                          return Builder(
                            builder: (context) {
                              if(list.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return LongPressDraggable<LeadCard>(
                                      data: LeadCard(
                                        lead: list[index],
                                      ),
                                      feedback: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        elevation: 0,
                                        type: MaterialType.card,
                                        child: Container(
                                          height: 125,
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: LeadCard(
                                            isDragging: true,
                                            lead: list[index],
                                          ),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LeadsPage(
                                                fromProject: true,
                                                project: widget.project,
                                                lead: list[index],
                                                leadStatuses: visibleStatuses,
                                              ),
                                            ),
                                          );

                                        },
                                        child: LeadCard(
                                          fromProject: true,
                                          project: widget.project,
                                          lead: list[index],
                                        ),
                                      ),
                                      childWhenDragging: SizedBox(
                                        height: 120,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: LocaleText("empty"),
                                );
                              }
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }else {
            return Loading();
          }
        }
      ),
    );
  }
}


