/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_state.dart';
import 'package:icrm/widgets/custom_text_field.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_person_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../core/models/projects_model.dart';

class AssignMembers extends StatelessWidget {
  const AssignMembers({
    Key? key,
    required this.id,
    this.lead,
    this.project,
    this.task,
  }) : super(key: key);

  final int id;
  final LeadsModel? lead;
  final TasksModel? task;
  final ProjectsModel? project;

  @override
  Widget build(BuildContext context) {
    context.read<TeamBloc>().add(TeamInitEvent());

    return AlertDialog(
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(vertical: 60),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 80,
        child: Column(
          children: [
            const SizedBox(height: 10),
            CustomTextField(
              suffixIcon: 'assets/icons_svg/search.svg',
              iconMargin: 15,
              iconColor: AppColors.greyDark,
              hint: 'search',
              controller: TextEditingController(),
              onChanged: (value) {},
              validator: (value) => null,
              isFilled: true,
              color: UserToken.isDark
                  ? AppColors.textFieldColorDark
                  : Colors.white,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<TeamBloc, TeamState>(
                builder: (context, state) {
                  if (state is TeamInitState && state.team.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.team.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          radius: 20,
                          onTap: () {
                            switch (id) {
                              case 1:
                                context.read<HomeBloc>().add(
                                  LeadsUpdateEvent(
                                    id: lead!.id,
                                    project_id: lead!.projectId,
                                    contact_id: lead!.contactId,
                                    start_date: lead!.startDate,
                                    end_date: lead!.endDate,
                                    estimated_amount: lead!.estimatedAmount,
                                    lead_status: lead!.leadStatusId,
                                    description: lead!.description,
                                    seller_id: state.team[index].id,
                                    currency: lead?.currency ?? "USD",
                                  ),
                                );
                                break;
                              case 2:
                                break;
                              case 3:
                                List<int> members = [];
                                for (int i = 0; i < project!.members!.length; i++) {
                                  members.add(project!.members![i].id);
                                }
                                members.add(state.team[index].id);
                                members.toSet();
                                context.read<ProjectsBloc>().add(ProjectsUpdateEvent(
                                  id: project!.id,
                                  name: project!.name,
                                  description: project!.description,
                                  project_status_id: project!.project_status_id,
                                  users: members,
                                ));
                                break;
                            }
                            Navigator.pop(context);
                          },
                          child: MainPersonContact(
                            name: state.team[index].first_name,
                            photo: state.team[index].social_avatar,
                            response: state.team[index].jobTitle,
                            phone_number: state.team[index].phoneNumber,
                            email: state.team[index].email,
                          ),
                        );
                      },
                    );
                  } else if (state is TeamInitState && state.team.isEmpty) {
                    return Center(
                      child: LocaleText('empty'),
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
    );
  }
}
