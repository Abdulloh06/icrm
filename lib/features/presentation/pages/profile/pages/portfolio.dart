
/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/portfolio_bloc/portfolio_bloc.dart';
import 'package:icrm/features/presentation/blocs/portfolio_bloc/portfolio_event.dart';
import 'package:icrm/features/presentation/blocs/portfolio_bloc/portfolio_state.dart';
import 'package:icrm/features/presentation/pages/profile/components/portfolio_card.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../core/util/colors.dart';


class Portfolio extends StatelessWidget {
  Portfolio({Key? key}) : super(key: key);

  final _controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'my_portfolio',
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Padding(
          padding: const EdgeInsets.all(20.0).copyWith(bottom: 0),
          child: BlocBuilder<PortfolioBloc, PortfolioState>(
            builder: (context, state) {
              if(state is PortfolioInitState && state.list.isNotEmpty) {
                return SmartRefresher(
                  enablePullUp: true,
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
                      if(status! == LoadStatus.loading) {
                        return Center(
                          child: RefreshProgressIndicator(
                            color: AppColors.mainColor,
                          ),
                        );
                      }else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  onRefresh: () {
                    context.read<PortfolioBloc>().add(PortfolioInitEvent());
                    _controller.refreshCompleted();
                  },
                  controller: _controller,
                  onLoading: () {
                    context.read<PortfolioBloc>().add(PortfolioGetNextPageEvent(list: state.list));
                    _controller.loadComplete();
                  },
                  child: ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      return PortfolioCard(
                        taskTitle: state.list[index].name,
                        category: state.list[index].description,
                        percent: 100,
                      );
                    },
                  ),
                );
              }else if(state is PortfolioInitState && state.list.isEmpty) {
                return Center(
                  child: LocaleText("empty", style: AppTextStyles.mainGrey),
                );
              }else {
                return Loading();
              }
            }
          ),
        ),
      ),
      bottomNavigationBar: MainBottomBar(isMain: false,),
    );
  }
}
