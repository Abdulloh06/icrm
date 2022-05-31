/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/cubits/swipe_animate_cubit.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:icrm/features/presentation/pages/home/components/dashboard.dart';
import 'package:icrm/features/presentation/pages/home/components/leads_list.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  static int? lead_status;
  final _controller = RefreshController();

  static bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: MainAppBar(
          isMainColor: UserToken.isDark ? true : false,
          scaffoldKey: scaffoldKey,
          elevation: 0,
          title: Text(
            'CRM',
            style: AppTextStyles.primary,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
          if (state is HomeInitState) {
            return SmartRefresher(
              enablePullUp: false,
              onRefresh: () {
                context.read<HomeBloc>().add(HomeInitEvent());
                HomePage.lead_status = null;
                _controller.refreshCompleted();
              },
              header: CustomHeader(
                refreshStyle: RefreshStyle.Behind,
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
                  if(status == LoadStatus.loading) {
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
              controller: _controller,
              child: Column(
                children: [
                  Stack(
                    children: [
                      DashBoard(state: state),
                      Visibility(
                        visible: state.dashboard.length > 4,
                        child: BlocBuilder<SwipeAnimationCubit, bool>(
                            builder: (context, state) {
                              return Visibility(
                                visible: state,
                                child: SizedBox(
                                  height: 200,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Lottie.asset(
                                      'assets/json_animations/swipe.json',
                                      height: 180,
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LocaleText(
                                'new_leads',
                                style: AppTextStyles.apppText.copyWith(
                                    color: UserToken.isDark
                                        ? Colors.white
                                        : Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  HomePage.lead_status = null;
                                  context.read<HomeBloc>().add(HomeInitEvent());
                                },
                                child: Row(
                                  children: [
                                    Text(Locales.string(context, 'all')),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                      "assets/icons_svg/up_icon.svg",
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(child: LeadsList(state: state)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Loading();
          }
        }),
      ),
    );
  }
}
