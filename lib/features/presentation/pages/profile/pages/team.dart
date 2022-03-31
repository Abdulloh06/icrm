import 'package:avlo/core/models/team_model.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:avlo/features/presentation/blocs/team_bloc/team_event.dart';
import 'package:avlo/features/presentation/blocs/team_bloc/team_state.dart';
import 'package:avlo/features/presentation/pages/profile/components/add_team_dialog.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_person_contact.dart';
import 'package:avlo/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avlo/widgets/main_tab_bar.dart';

class MyTeam extends StatelessWidget {
  MyTeam({Key? key}) : super(key: key);

  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    context.read<TeamBloc>().add(TeamInitEvent());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 52),
          child: AppBarBack(
            title: 'team',
          ),
        ),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainTabBar(
                  tabs: [
                    Tab(text: Locales.string(context, 'all')),
                    Tab(text: Locales.string(context, 'seldom')),
                    Tab(text: Locales.string(context, 'often')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MainSearchBar(
                  onComplete: () => FocusScope.of(context).unfocus(),
                  controller: _searchController,
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AddTeamDialog();
                      },
                    );
                  },
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          children: [
                            LocaleText(
                              'add',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            const SizedBox(width: 5),
                            SvgPicture.asset(
                                'assets/icons_svg/add_small.svg'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: BlocBuilder<TeamBloc, TeamState>(
                    builder: (context, state) {
                      if (state is TeamInitState) {
                        List<TeamModel> seldom = state.team
                            .where((element) => element.is_often == 1)
                            .toList();
                        List<TeamModel> often = state.team
                            .where((element) => element.is_often == 0)
                            .toList();

                        return TabBarView(
                          children: [
                            Visibility(
                              replacement: Align(
                                alignment: Alignment.topCenter,
                                child: LocaleText('empty'),
                              ),
                              visible: state.team.isNotEmpty,
                              child: ListView.builder(
                                itemCount: state.team.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    margin:
                                        const EdgeInsets.only(bottom: 10),
                                    child: MainPersonContact(
                                      name: state.team[index].first_name +
                                          " " +
                                          state.team[index].last_name,
                                      response:
                                          state.team[index].jobTitle,
                                      photo: state.team[index].social_avatar,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              replacement: Center(
                                child: LocaleText(
                                  'empty',
                                  style: AppTextStyles.mainGrey,
                                ),
                              ),
                              visible: seldom.isNotEmpty,
                              child: ListView.builder(
                                itemCount: seldom.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    margin:
                                        const EdgeInsets.only(bottom: 10),
                                    child: MainPersonContact(
                                      name: seldom[index].first_name +
                                          " " +
                                          seldom[index].last_name,
                                      response: seldom[index].jobTitle,
                                      photo: seldom[index].social_avatar,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              replacement: Center(
                                child: LocaleText(
                                  'empty',
                                  style: AppTextStyles.mainGrey,
                                ),
                              ),
                              visible: often.isNotEmpty,
                              child: ListView.builder(
                                itemCount: often.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    margin:
                                        const EdgeInsets.only(bottom: 10),
                                    child: MainPersonContact(
                                      name: often[index].first_name +
                                          " " +
                                          often[index].last_name,
                                      response: often[index].jobTitle,
                                      photo: often[index].social_avatar,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
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
        ),
      ),
    );
  }
}
