import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:avlo/features/presentation/pages/project/pages/project_structe.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../widgets/main_button.dart';

class CreateProject extends StatelessWidget {
  const CreateProject({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: MainAppBar(
          elevation: 0,
          isMainColor: UserToken.isDark ? true : false,
          scaffoldKey: scaffoldKey,
          title: 'projects',
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Padding(
          padding: const EdgeInsets.all(20.0).copyWith(bottom: 0),
          child: BlocConsumer<ProjectsBloc, ProjectsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if(state is ProjectsInitState && state.projects.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.projects.length,
                  itemBuilder: (context, index) {
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
                                  context, 'you_want_delete_project',
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
                                        context.read<ProjectsBloc>().add(ProjectsDeleteEvent(id: state.projects[index].id));
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectStructure(
                        name: state.projects[index].name,
                        id: state.projects[index].id,
                        description: state.projects[index].description,
                        created_at: state.projects[index].created_at,
                        updated_at: state.projects[index].updated_at,
                        project_status_id: state.projects[index].project_status_id,
                        user_category: state.projects[index].user_category_id,
                        user_id: state.projects[index].user_id,
                        price: state.projects[index].price,
                        notify_at: state.projects[index].notify_at,
                        currency: state.projects[index].currency,
                        leads: state.projects[index].leads ?? [],
                        tasks: state.projects[index].tasks ?? [],
                        company_id: state.projects[index].company_id,
                      ))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        decoration: BoxDecoration(
                          color: UserToken.isDark ? AppColors.mainDark : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                state.projects[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.proText.copyWith(
                                  color: !UserToken.isDark ? AppColors.mainColor : Colors.white,
                                ),
                              ),
                            ),
                            SvgPicture.asset("assets/icons_svg/vect.svg"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if(state is ProjectsInitState && state.projects.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/png/empty.png'),
                      LocaleText("unfortunately_nothing_yet"),
                    ],
                  ),
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
      ),
    );
  }
}

