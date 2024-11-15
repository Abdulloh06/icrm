/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/helper_bloc/helper_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/blocs/user_categories_bloc/user_categories_bloc.dart';
import 'package:icrm/features/presentation/blocs/user_categories_bloc/user_categories_event.dart';
import 'package:icrm/features/presentation/blocs/user_categories_bloc/user_categories_state.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/main_button.dart';
import '../../../blocs/helper_bloc/helper_event.dart';
import '../../leads/components/main_info.dart';

class UserCategories extends StatelessWidget {
  UserCategories({
    Key? key,
    this.fromProject = true,
    this.project,
  }) : super(key: key);

  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool fromProject;
  final ProjectsModel? project;

  void addCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.all(20),
          title: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  hint: 'categories',
                  controller: _categoryController,
                  onChanged: (value) {},
                  validator: (value) => value!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
                  isFilled: true,
                  color: UserToken.isDark ? AppColors.textFieldColorDark : AppColors.textFieldColor,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainButton(
                      color: AppColors.red,
                      title: 'no',
                      onTap: () => Navigator.pop(context),
                      fontSize: 18,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                    ),
                    const SizedBox(width: 10),
                    MainButton(
                      onTap: () {
                        if(_formKey.currentState!.validate()) {
                          context.read<UserCategoriesBloc>().add(UserCategoriesAddEvent(name: _categoryController.text));
                          Navigator.pop(context);
                        }
                      },
                      color: AppColors
                          .mainColor,
                      title: 'yes',
                      fontSize: 18,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserCategoriesBloc>().add(UserCategoriesInitEvent());

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => addCategory(context),
            child: Container(
              decoration: BoxDecoration(
                color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: LocaleText(
                      'add_category',
                      style: AppTextStyles.mainGrey
                          .copyWith(color: AppColors.mainColor),
                    ),
                  ),
                  SvgPicture.asset('assets/icons_svg/add_icon.svg', height: 30),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: BlocBuilder<UserCategoriesBloc, UserCategoriesState>(
              builder: (context, state) {
                if (state is UserCategoriesInitState && state.list.isEmpty) {
                  return Center(
                    child: LocaleText(
                      "empty",
                      style: AppTextStyles.mainGrey,
                    ),
                  );
                } else if (state is UserCategoriesInitState && state.list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        background: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons_svg/delete.svg',
                                height: 20,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/icons_svg/delete.svg',
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        key: Key(state.list[index].id.toString()),
                        onDismissed: (direction) {
                          context.read<UserCategoriesBloc>().add(
                            UserCategoriesDeleteEvent(id: state.list[index].id),
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            if(fromProject) {
                              context.read<HelperBloc>().add(HelperProjectMainEvent(type: 3, id: state.list[index].id, name: state.list[index].title));
                              Navigator.pop(context);
                            }else {
                              List<int> users = [];
                              for(int i = 0; i < project!.members!.length; i++) {
                                users.add(project!.members![i].id);
                              }
                              context.read<ProjectsBloc>().add(
                                ProjectsUpdateEvent(
                                  id: project!.id,
                                  project_status_id: project!.project_status_id,
                                  name: project!.name,
                                  user_category_id: state.list[index].id,
                                  users: users,
                                  description: '',
                                ),
                              );
                              MainLeadInfo.userCategory = state.list[index].title;
                              context.read<HomeBloc>().add(HomeInitEvent());
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons_svg/dottt.svg', height: 8, color: Colors.white,),
                                const SizedBox(width: 5),
                                Text(
                                  state.list[index].title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if(state is UserCategoriesErrorState) {
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
    );
  }
}
