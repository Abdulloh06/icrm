/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:icrm/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:icrm/widgets/main_button.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
      contentPadding: const EdgeInsets.all(10).copyWith(top: 0),
      titlePadding: const EdgeInsets.all(20),
      insetPadding: const EdgeInsets.only(bottom: 100, top: 60),
      title: Form(
        key: _formKey,
        child: MainSearchBar(
          validator: (value) => value!.isEmpty
              ? Locales.string(context, 'must_fill_this_line')
              : value.length < 5 ? Locales.string(context, 'min_amount_symbols') : null,
          fillColor: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
          controller: _searchController,
          helperText: Locales.string(context, "type_phone_of_user"),
          icon: IconButton(
            icon: Icon(
              Icons.check,
              color: AppColors.mainColor,
            ),
            splashRadius: 10,
            onPressed: () {
              if(_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();
                context.read<UsersBloc>().add(
                  UsersInitEvent(
                    search: _searchController.text,
                  ),
                );
              }
            },
          ),
          onComplete: () {
            if(_formKey.currentState!.validate()) {
              FocusScope.of(context).unfocus();
              context.read<UsersBloc>().add(
                UsersInitEvent(
                  search: _searchController.text,
                ),
              );
            }
          },
          onChanged: (value) {},
        ),
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
                        email: state.users[index].email,
                      ),
                    ),
                  );
                },
              );
            } else if(state is UsersInitState && state.users.isEmpty) {
              return SizedBox(
                height: 40,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: MainButton(
                    color: AppColors.mainColor,
                    title: 'invite',
                    padding: const EdgeInsets.all(0),
                    onTap: () {
                      if(_formKey.currentState!.validate()) {
                        context.read<TeamBloc>().add(
                          TeamInviteEvent(
                            via: _searchController.text,
                            model_type: 'task',
                            model_id: 1,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              );
            }else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
