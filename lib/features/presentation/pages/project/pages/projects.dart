/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:icrm/features/presentation/pages/project/pages/project_structe.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../widgets/main_button.dart';

class CreateProject extends StatefulWidget {
  CreateProject({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: MainAppBar(
          elevation: 0,
          isMainColor: UserToken.isDark ? true : false,
          scaffoldKey: widget.scaffoldKey,
          title: 'projects',
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Padding(
          padding: const EdgeInsets.all(20.0).copyWith(bottom: 0),
          child: BlocConsumer<ProjectsBloc, ProjectsState>(
            listener: (context, state) {
              if(state is ProjectsErrorState) {
                print('something_went_wrong');
                print(state.error);
                context.read<ProjectsBloc>().add(ProjectsInitEvent());
              }
            },
            builder: (context, state) {
              if(state is ProjectsInitState && state.projects.isNotEmpty) {
                return SmartRefresher(
                  enablePullUp: state.projects.length > 14 ? !ProjectsInitState.hasReachedMax : false,
                  onRefresh: () {
                    context.read<ProjectsBloc>().add(ProjectsInitEvent());
                    _controller.refreshCompleted();
                  },
                  onLoading: () {
                    context.read<ProjectsBloc>().add(ProjectsNextPageEvent(list: state.projects));
                    _controller.loadComplete();
                    setState(() {});
                  },
                  header: CustomHeader(
                    builder: (context, status) {
                      return Center(
                        child: RefreshProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      );
                    },
                  ),
                  footer: CustomFooter(
                    builder: (context, status) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      );
                    },
                  ),
                  controller: _controller,
                  child: ListView.builder(
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
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectStructure(
                            project: state.projects[index],
                            projectStatus: state.projectStatus,
                          )));
                        },
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
                  ),
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
                return const Loading();
              }
            },
          ),
        ),
      ),
    );
  }
}

