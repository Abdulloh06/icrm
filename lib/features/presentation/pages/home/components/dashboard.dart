import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:flutter/material.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../blocs/home_bloc/home_bloc.dart';
import '../../../blocs/home_bloc/home_event.dart';
import '../../leads/components/lead_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/home_page.dart';
import 'main_categories.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({
    Key? key,
    required this.state,
  }) : super(key: key);

  final HomeInitState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 265,
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.mainDark : Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 15,
          childAspectRatio: MediaQuery.of(context).size.height * 0.0022,
          children: [
            DragTarget<LeadCard>(
              onAccept: (object) {
                if (state.dashboard.isNotEmpty) {
                  context.read<HomeBloc>().add(LeadsUpdateEvent(
                    id: object.lead.id,
                    project_id: object.lead.projectId,
                    contact_id: object.lead.contactId ?? null,
                    start_date: object.lead.startDate,
                    end_date: object.lead.endDate,
                    estimated_amount: object.lead.estimatedAmount,
                    lead_status: state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 0)).id)).lead_status_id,
                    seller_id: object.lead.seller_id,
                    description: object.lead.description,
                    currency: object.lead.currency,
                  ));
                }
              },
              builder: (context, object, list) {
                return GestureDetector(
                  onTap: () {
                    if (state.dashboard.isNotEmpty) {
                      HomePage.lead_status = state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 0)).id)).lead_status_id;
                      context.read<HomeBloc>().add(HomeInitEvent());
                    }
                  },
                  child: MainCategory(
                    title: 'received',
                    icon: 'assets/icons_svg/received.svg',
                    length: state.dashboard.isNotEmpty
                        ? state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 0)).id)).number
                        : 0,
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(5)
                        .copyWith(
                        topLeft: const Radius.circular(20)),
                  ),
                );
              },
            ),
            DragTarget<LeadCard>(
              onAccept: (object) {
                if (state.dashboard.length > 2) {
                  context.read<HomeBloc>().add(LeadsUpdateEvent(
                    id: object.lead.id,
                    project_id: object.lead.projectId,
                    contact_id: object.lead.contactId ?? null,
                    start_date: object.lead.startDate,
                    end_date: object.lead.endDate,
                    estimated_amount:
                    object.lead.estimatedAmount,
                    lead_status:
                    state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 1)).id)).lead_status_id,
                    seller_id: object.lead.seller_id,
                    description: object.lead.description,
                    currency: object.lead.currency,
                  ));
                }
              },
              builder: (context, object, list) {
                return GestureDetector(
                  onTap: () {
                    if (state.dashboard.length > 2) {
                      HomePage.lead_status = state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 1)).id)).lead_status_id;
                      context
                          .read<HomeBloc>()
                          .add(HomeInitEvent());
                    }
                  },
                  child: MainCategory(
                    title: 'in_progress',
                    icon: 'assets/icons_svg/in_progress.svg',
                    length: state.dashboard.length > 2 ? state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 1)).id)).number : 0,
                    color: AppColors.mainYellow,
                    borderRadius: BorderRadius.circular(5)
                        .copyWith(topRight: const Radius.circular(20),
                    ),
                  ),
                );
              },
            ),
            DragTarget<LeadCard>(
              onAccept: (object) {
                if (state.dashboard.length > 2) {
                  context.read<HomeBloc>().add(LeadsUpdateEvent(
                    id: object.lead.id,
                    project_id: object.lead.projectId,
                    contact_id: object.lead.contactId ?? null,
                    start_date: object.lead.startDate,
                    end_date: object.lead.endDate,
                    estimated_amount: object.lead.estimatedAmount,
                    lead_status: state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 10000)).id)).lead_status_id,
                    seller_id: object.lead.seller_id,
                    description: object.lead.description,
                    currency: object.lead.currency ?? "USD",
                  ));
                }
              },
              builder: (context, object, list) {
                return GestureDetector(
                  onTap: () {
                    if (state.dashboard.length > 2) {
                      HomePage.lead_status =
                          state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 10000)).id)).lead_status_id;
                      context
                          .read<HomeBloc>()
                          .add(HomeInitEvent());
                    }
                  },
                  child: MainCategory(
                    title: 'completed',
                    icon: 'assets/icons_svg/completed.svg',
                    length: state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == 10000)).id)).number,
                    color: AppColors.green,
                    borderRadius:
                    BorderRadius.circular(5).copyWith(
                      bottomLeft: const Radius.circular(20),
                    ),
                  ),
                );
              },
            ),
            DragTarget<LeadCard>(
              onAccept: (object) {
                if (state.dashboard.length > 3) {
                  context.read<HomeBloc>().add(LeadsUpdateEvent(
                    id: object.lead.id,
                    project_id: object.lead.projectId,
                    contact_id: object.lead.contactId ?? null,
                    start_date: object.lead.startDate,
                    end_date: object.lead.endDate,
                    estimated_amount:
                    object.lead.estimatedAmount,
                    lead_status:
                    state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == -1)).id)).lead_status_id,
                    seller_id: object.lead.seller_id,
                    description: object.lead.description,
                    currency: object.lead.currency,
                  ));
                }
              },
              builder: (context, object, list) {
                return GestureDetector(
                  onTap: () {
                    if (state.dashboard.length > 3) {
                      HomePage.lead_status =
                          state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == -1)).id)).lead_status_id;
                      context
                          .read<HomeBloc>()
                          .add(HomeInitEvent());
                    }
                  },
                  child: MainCategory(
                    title: 'canceled',
                    icon: 'assets/icons_svg/canceled.svg',
                    length: state.dashboard.length < 4
                        ? 0
                        : state.dashboard.elementAt(state.dashboard.indexWhere((element) => element.lead_status_id == state.leadStatus.elementAt(state.leadStatus.indexWhere((element) => element.sequence == -1)).id)).number,
                    color: Color(0xffFF6157),
                    borderRadius: BorderRadius.circular(5)
                        .copyWith(
                        bottomRight:
                        const Radius.circular(20)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
