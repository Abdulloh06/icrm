/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:icrm/features/presentation/pages/leads/components/lead_card.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/main_button.dart';
import '../../../../../widgets/main_tab_bar.dart';
import '../../leads/pages/leads_page.dart';

class ProjectLeadPage extends StatefulWidget {
  const ProjectLeadPage({
    Key? key,
    required this.projectId,

  }) : super(key: key);

  final int projectId;
  @override
  State<ProjectLeadPage> createState() => _ProjectLeadPageState();
}

class _ProjectLeadPageState extends State<ProjectLeadPage> {

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if(state is HomeInitState) {

          return DefaultTabController(
            length: state.leadStatus.length,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LocaleText(
                        'task_status_name',
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
                            isScrollable: state.leadStatus.length >= 4,
                            labelPadding: state.leadStatus.length >= 4 ? const EdgeInsets.symmetric(horizontal: 12, vertical: 0) : const EdgeInsets.all(0),
                            shadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color.fromARGB(40, 0, 0, 0),
                              ),
                            ],
                            tabs: List.generate(state.leadStatus.length,
                                    (index) {
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
                                                        horizontal: 50, vertical: 10),
                                                  ),
                                                  MainButton(
                                                    onTap: () {
                                                      context.read<HomeBloc>().add(LeadsStatusDeleteEvent(id: state.leadStatus[index].id));
                                                      Navigator.pop(context);
                                                    },
                                                    color: AppColors.mainColor,
                                                    title: 'yes',
                                                    fontSize: 22,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 50, vertical: 10),
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
                                        if (state.leadStatus.isNotEmpty) {
                                          context.read<HomeBloc>().add(LeadsUpdateEvent(
                                            id: object.lead.id,
                                            project_id: object.lead.projectId,
                                            contact_id: object.lead.contactId ?? null,
                                            start_date: object.lead.startDate,
                                            end_date: object.lead.endDate,
                                            estimated_amount: object.lead.estimatedAmount,
                                            lead_status: state.leadStatus[index].id,
                                            seller_id: object.lead.seller_id,
                                            description: object.lead.description,
                                            currency: object.lead.currency,
                                          ));
                                        }
                                      },
                                      builder: (context, accept, reject) {
                                        String title = state.leadStatus[index].name;

                                        return Visibility(
                                          replacement: Container(
                                            width: 70,
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                              initialValue: state.leadStatus[index].name,
                                              onChanged: (value) {
                                                title = value;
                                              },
                                              onEditingComplete: () {
                                                context.read<HomeBloc>().add(LeadsStatusUpdateEvent(id: state.leadStatus[index].id,name: title));
                                              },
                                            ),
                                          ),
                                          visible: !isEdit,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              state.leadStatus[index].name,
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
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: TextField(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: AppColors.greyLight),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.5, color: AppColors.mainColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      title = value;
                                    },
                                  ),
                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          MainButton(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                            color: AppColors.red,
                                            title: 'cancel',
                                          ),
                                          MainButton(
                                            onTap: () {
                                              if(title != '') {
                                                context.read<HomeBloc>().add(LeadsAddStatusEvent(name: title));
                                              }
                                              Navigator.pop(context);
                                            },
                                            color: AppColors.green,
                                            title: 'save',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
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
                      children: List.generate(state.leadStatus.length, (i) {

                        List<LeadsModel> leads = state.leads.where((element) => element.projectId == widget.projectId && element.leadStatusId == state.leadStatus[i].id).toList();

                        return Visibility(
                          replacement: Center(
                            child: LocaleText('empty'),
                          ),
                          visible: leads.isNotEmpty,
                          child: ListView.builder(
                            itemCount: leads.length,
                            itemBuilder: (context, index) {
                              return LongPressDraggable<LeadCard>(
                                data: LeadCard(
                                  lead: state.leads[index],
                                ),
                                feedback: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 0,
                                  type: MaterialType.card,
                                  child: Container(
                                    height: 120,
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: LeadCard(
                                      isDragging: true,
                                      lead: state.leads[index],
                                    ),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LeadsPage(
                                          lead: state.leads[index],
                                          leadStatuses: state.leadStatus,
                                          phone_number: state.leads[index].contact != null ? state.leads[index].contact!.phone_number : "",
                                        ),
                                      ),
                                    );

                                  },
                                  child: LeadCard(
                                    lead: state.leads[index],
                                  ),
                                ),
                                childWhenDragging: SizedBox(
                                  height: 175,
                                ),
                              );
                            },
                          ),
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
    );
  }
}


