/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_event.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_state.dart';
import 'package:icrm/widgets/custom_text_field.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_person_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';


class AddMembers extends StatelessWidget {

  AddMembers({
    Key? key,
    required this.id,
    this.members,
  }) : super(key: key);

  final int id;
  final List<TeamModel>? members;
  final _searchController = TextEditingController();

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
              controller: _searchController,
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
                      itemCount: members != null && members!.isNotEmpty ? members!.length : state.team.length,
                      itemBuilder: (context, index) {
                        return Visibility(
                          visible: members != null && members!.isNotEmpty ? state.team.any((element) => element.id == members![index].id) : true,
                          child: InkWell(
                            radius: 20,
                            onTap: () {
                              if(id == 1) {
                                context.read<HelperBloc>().add(HelperLeadMemberEvent(member: TeamModel(
                                  id: state.team[index].id,
                                  social_avatar: state.team[index].social_avatar,
                                  first_name: state.team[index].first_name,
                                  last_name: state.team[index].last_name,
                                  email: state.team[index].email,
                                  phoneNumber: state.team[index].phoneNumber,
                                  username: state.team[index].username,
                                  jobTitle: state.team[index].jobTitle,
                                  is_often: state.team[index].is_often,
                                )));

                                }else if(id == 2) {
                                  context.read<HelperBloc>().add(HelperProjectMemberEvent(member: TeamModel(
                                    id: state.team[index].id,
                                    social_avatar: state.team[index].social_avatar,
                                    first_name: state.team[index].first_name,
                                    last_name: state.team[index].last_name,
                                    email: state.team[index].email,
                                    phoneNumber: state.team[index].phoneNumber,
                                    username: state.team[index].username,
                                    jobTitle: state.team[index].jobTitle,
                                    is_often: state.team[index].is_often,
                                  )));
                                }else {
                                  context.read<HelperBloc>().add(HelperTaskMemberEvent(member: TeamModel(
                                    id: state.team[index].id,
                                    social_avatar: state.team[index].social_avatar,
                                    first_name: state.team[index].first_name,
                                    last_name: state.team[index].last_name,
                                    email: state.team[index].email,
                                    phoneNumber: state.team[index].phoneNumber,
                                    username: state.team[index].username,
                                    jobTitle: state.team[index].jobTitle,
                                    is_often: state.team[index].is_often,
                                  )));
                                }
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: MainPersonContact(
                                  name: state.team[index].first_name,
                                  photo: state.team[index].social_avatar,
                                  response: state.team[index].jobTitle,
                                  phone_number: state.team[index].phoneNumber,
                                  email: state.team[index].email,
                                ),
                              ),
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
