import 'package:avlo/features/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:avlo/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../../../../core/util/colors.dart';
import '../../../../../widgets/main_person_contact.dart';
import '../../../../../widgets/main_search_bar.dart';
import '../../../blocs/users_bloc/users_bloc.dart';
import '../../../blocs/users_bloc/users_state.dart';

class AddTeamDialog extends StatelessWidget {
  AddTeamDialog({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<UsersBloc>().add(UsersInitEvent(search: ''));

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(10).copyWith(top: 0),
        titlePadding: const EdgeInsets.all(20),
        insetPadding: const EdgeInsets.only(bottom: 100, top: 60),
        title: MainSearchBar(
          controller: _searchController,
          onComplete: () {
            FocusScope.of(context).unfocus();
            context.read<UsersBloc>().add(
              UsersInitEvent(
                search: _searchController.text,
              ),
            );
          },
          onChanged: (value) {
            context.read<UsersBloc>().add(
              UsersInitEvent(
                search: _searchController.text,
              ),
            );
          },
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              if (state is UsersInitState && state.users.isNotEmpty && _searchController.text.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemExtent: MediaQuery.of(context).size.height * 0.1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          context.read<TeamBloc>().add(TeamAddEvent(id: state.users[index].id));
                          Navigator.pop(context);
                        },
                        child: MainPersonContact(
                          name: state.users[index].first_name,
                          response: state.users[index].jobTitle,
                          phone_number: state.users[index].social_avatar,
                          photo: state.users[index].social_avatar,
                        ),
                      ),
                    );
                  },
                );
              } else if(state is UsersInitState && state.users.isEmpty){
                return Center(
                  child: LocaleText("empty"),
                );
              } else if(state is UsersLoadingState){
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                );
              }else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
