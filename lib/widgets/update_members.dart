/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_state.dart';
import 'package:icrm/widgets/custom_text_field.dart';
import 'package:icrm/widgets/main_person_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';


class UpdateMembers extends StatelessWidget {

  const UpdateMembers({
    Key? key,
    required this.task_id,
    required this.assigns,
  }) : super(key: key);

  final int task_id;
  final List<int> assigns;

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
              color: UserToken.isDark ? AppColors.textFieldColorDark : Colors.white,
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
                            assigns.add(state.team[index].id);
                            assigns.toSet();
                            context.read<TasksBloc>().add(TasksAssignUsersEvent(users: assigns, id: task_id));
                            Navigator.pop(context);
                          },
                          child: MainPersonContact(
                            name: state.team[index].first_name,
                            photo: state.team[index].social_avatar,
                            response: state.team[index].jobTitle,
                          ),
                        );
                      },
                    );
                  } else if (state is TeamInitState && state.team.isEmpty) {
                    return Center(
                      child: LocaleText('empty'),
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
            ),
          ],
        ),
      ),
    );
  }
}
