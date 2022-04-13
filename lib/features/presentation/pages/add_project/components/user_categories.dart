/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/blocs/user_categories_bloc/user_categories_bloc.dart';
import 'package:icrm/features/presentation/blocs/user_categories_bloc/user_categories_event.dart';
import 'package:icrm/features/presentation/blocs/user_categories_bloc/user_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../widgets/custom_text_field.dart';

class UserCategories extends StatelessWidget {
  UserCategories({Key? key}) : super(key: key);

  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void addCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Form(
            key: _formKey,
            child: CustomTextField(
              hint: 'categories',
              controller: _categoryController,
              onChanged: (value) {},
              validator: (value) => value!.isEmpty ? Locales.string(context, 'must_fill_this_line') : null,
              onEditingComplete: () {
                if(_formKey.currentState!.validate()) {
                  context.read<UserCategoriesBloc>().add(UserCategoriesAddEvent(name: _categoryController.text));
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

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
                      return GestureDetector(
                        onTap: () {
                          context.read<ProjectsBloc>().add(ProjectsUserCategoryEvent(id: state.list[index].id, name: state.list[index].title));
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 23),
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
                      );
                    },
                  );
                } else if(state is UserCategoriesErrorState) {
                  return Center(
                    child: Text(state.error),
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
    );
  }
}
