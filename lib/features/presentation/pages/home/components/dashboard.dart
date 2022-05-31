/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/dash_board_model.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:flutter/material.dart';
import '../../../../../core/models/dash_board_model.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../blocs/home_bloc/home_bloc.dart';
import '../../../blocs/home_bloc/home_event.dart';
import '../../leads/components/lead_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/home_page.dart';
import 'main_categories.dart';

class DashBoard extends StatefulWidget {
  DashBoard({
    Key? key,
    required this.state,
  }) : super(key: key);

  final HomeInitState state;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late String pending;
  late String inProgress;
  late String completed;
  late String canceled;

  void _getCount() {
    try {
      DashBoardModel model = widget.state.dashboard
          .where((element) => element.lead_status_id == 3)
          .first;
      UserToken.canceledTask = model.number;
      canceled = model.name;
    } catch (_) {
      canceled = '';
    }
    try {
      DashBoardModel model = widget.state.dashboard
          .where((element) => element.lead_status_id == 1)
          .first;
      UserToken.pendingTask = model.number;
      pending = model.name;
    } catch (_) {
      pending = '';
    }
    try {
      DashBoardModel model = widget.state.dashboard
          .where((element) => element.lead_status_id == 2)
          .first;
      UserToken.inProgressTask = model.number;
      inProgress = model.name;
    } catch (_) {
      inProgress = '';
    }
    try {
      DashBoardModel model = widget.state.dashboard
          .where((element) => element.lead_status_id == 10)
          .first;
      UserToken.completedTask = model.number;
      completed = model.name;
    } catch (_) {
      completed = '';
    }
  }

  @override
  void initState() {
    super.initState();
    _getCount();
  }

  @override
  Widget build(BuildContext context) {
    List<DashBoardModel> list = widget.state.dashboard.where((element) =>
    element.lead_status_id != 1
        && element.lead_status_id != 2
        && element.lead_status_id != 3
        && element.lead_status_id != 10
    ).toList();
    return Container(
      height: MediaQuery.of(context).size.height > 550 ? 250 : 200,
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.mainDark : Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        child: Builder(
          builder: (context) {
            if (list.isNotEmpty) {
              return PageView(
                children: [
                  GridView.count(
                    padding: const EdgeInsets.all(20),
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.8,
                    children: [
                      DragTarget<LeadCard>(
                        onAccept: (object) {
                          try {
                            context.read<HomeBloc>().add(LeadsUpdateEvent(
                              id: object.lead.id,
                              project_id: object.lead.projectId,
                              contact_id: object.lead.contactId ?? null,
                              start_date: object.lead.startDate,
                              end_date: object.lead.endDate,
                              estimated_amount: object.lead.estimatedAmount,
                              lead_status: 1,
                              seller_id: object.lead.seller_id,
                              description: object.lead.description,
                              currency: object.lead.currency,
                            ));
                          } catch (_) {}
                        },
                        builder: (context, object, list) {
                          return GestureDetector(
                            onTap: () {
                              try {
                                HomePage.lead_status = 1;
                                context.read<HomeBloc>().add(HomeInitEvent());
                              } catch (_) {}
                            },
                            child: MainCategory(
                              title: pending,
                              icon: 'assets/icons_svg/received.svg',
                              length: UserToken.pendingTask,
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(5)
                                  .copyWith(topLeft: const Radius.circular(20)),
                            ),
                          );
                        },
                      ),
                      DragTarget<LeadCard>(
                        onAccept: (object) {
                          try {
                            context.read<HomeBloc>().add(LeadsUpdateEvent(
                              id: object.lead.id,
                              project_id: object.lead.projectId,
                              contact_id: object.lead.contactId ?? null,
                              start_date: object.lead.startDate,
                              end_date: object.lead.endDate,
                              estimated_amount: object.lead.estimatedAmount,
                              lead_status: 2,
                              seller_id: object.lead.seller_id,
                              description: object.lead.description,
                              currency: object.lead.currency,
                            ));
                          } catch (_) {}
                        },
                        builder: (context, object, list) {
                          return GestureDetector(
                            onTap: () {
                              try {
                                HomePage.lead_status = 2;
                                context.read<HomeBloc>().add(HomeInitEvent());
                              } catch (_) {}
                            },
                            child: MainCategory(
                              title: inProgress,
                              icon: 'assets/icons_svg/in_progress.svg',
                              length: UserToken.inProgressTask,
                              color: AppColors.mainYellow,
                              borderRadius: BorderRadius.circular(5).copyWith(
                                topRight: const Radius.circular(20),
                              ),
                            ),
                          );
                        },
                      ),
                      DragTarget<LeadCard>(
                        onAccept: (object) {
                          try {
                            context.read<HomeBloc>().add(LeadsUpdateEvent(
                              id: object.lead.id,
                              project_id: object.lead.projectId,
                              contact_id: object.lead.contactId ?? null,
                              start_date: object.lead.startDate,
                              end_date: object.lead.endDate,
                              estimated_amount: object.lead.estimatedAmount,
                              lead_status: 10,
                              seller_id: object.lead.seller_id,
                              description: object.lead.description,
                              currency: object.lead.currency,
                            ));
                          } catch (_) {}
                        },
                        builder: (context, object, list) {
                          return GestureDetector(
                            onTap: () {
                              try {
                                HomePage.lead_status = 10;
                                context.read<HomeBloc>().add(HomeInitEvent());
                              } catch (_) {}
                            },
                            child: MainCategory(
                              title: completed,
                              icon: 'assets/icons_svg/completed.svg',
                              length: UserToken.completedTask,
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(5).copyWith(
                                bottomLeft: const Radius.circular(20),
                              ),
                            ),
                          );
                        },
                      ),
                      DragTarget<LeadCard>(
                        onAccept: (object) {
                          try {
                            context.read<HomeBloc>().add(LeadsUpdateEvent(
                              id: object.lead.id,
                              project_id: object.lead.projectId,
                              contact_id: object.lead.contactId ?? null,
                              start_date: object.lead.startDate,
                              end_date: object.lead.endDate,
                              estimated_amount: object.lead.estimatedAmount,
                              lead_status: 3,
                              seller_id: object.lead.seller_id,
                              description: object.lead.description,
                              currency: object.lead.currency,
                            ));
                          } catch (_) {}
                        },
                        builder: (context, object, list) {
                          return GestureDetector(
                            onTap: () {
                              try {
                                HomePage.lead_status = 3;
                                context.read<HomeBloc>().add(HomeInitEvent());
                              } catch (_) {}
                            },
                            child: MainCategory(
                              title: canceled,
                              icon: 'assets/icons_svg/canceled.svg',
                              length: UserToken.canceledTask,
                              color: Color(0xffFF6157),
                              borderRadius: BorderRadius.circular(5)
                                  .copyWith(
                                  bottomRight: const Radius.circular(20)),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.8,
                    padding: const EdgeInsets.all(20).copyWith(
                      left: 20,
                    ),
                    children: List.generate(list.length, (index) {
                      BorderRadius radius = BorderRadius.circular(5);
                      switch (index) {
                        case 0:
                          radius = BorderRadius.circular(5)
                              .copyWith(topLeft: const Radius.circular(20));
                          break;
                        case 1:
                          radius = BorderRadius.circular(5).copyWith(
                              topRight: const Radius.circular(20));
                          break;
                        case 2:
                          radius = BorderRadius.circular(5).copyWith(
                              bottomLeft: const Radius.circular(20));
                          break;
                        case 3:
                          radius = BorderRadius.circular(5)
                              .copyWith(bottomRight: const Radius.circular(20));
                          break;
                      }
                      return DragTarget<LeadCard>(
                        onAccept: (object) {
                          try {
                            context.read<HomeBloc>().add(LeadsUpdateEvent(
                              id: object.lead.id,
                              project_id: object.lead.projectId,
                              contact_id: object.lead.contactId ?? null,
                              start_date: object.lead.startDate,
                              end_date: object.lead.endDate,
                              estimated_amount: object.lead.estimatedAmount,
                              lead_status: list[index].lead_status_id,
                              seller_id: object.lead.seller_id,
                              description: object.lead.description,
                              currency: object.lead.currency,
                            ));
                          } catch (_) {}
                        },
                        builder: (context, object, val) {
                          return GestureDetector(
                            onTap: () {
                              try {
                                HomePage.lead_status =
                                    list[index].lead_status_id;
                                context.read<HomeBloc>().add(HomeInitEvent());
                              } catch (_) {}
                            },
                            child: MainCategory(
                              title: list[index].name,
                              length: list[index].number,
                              icon: 'assets/icons_svg/in_progress.svg',
                              borderRadius: radius,
                              color: Color(
                                int.parse(
                                    list[index].color.split('#').join('0xff')),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              );
            } else {
              return GridView.count(
                padding: const EdgeInsets.all(20),
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 15,
                childAspectRatio: 1.8,
                children: [
                  DragTarget<LeadCard>(
                    onAccept: (object) {
                      try {
                        context.read<HomeBloc>().add(LeadsUpdateEvent(
                          id: object.lead.id,
                          project_id: object.lead.projectId,
                          contact_id: object.lead.contactId ?? null,
                          start_date: object.lead.startDate,
                          end_date: object.lead.endDate,
                          estimated_amount: object.lead.estimatedAmount,
                          lead_status: 1,
                          seller_id: object.lead.seller_id,
                          description: object.lead.description,
                          currency: object.lead.currency,
                        ));
                      } catch (_) {}
                    },
                    builder: (context, object, list) {
                      return GestureDetector(
                        onTap: () {
                          try {
                            HomePage.lead_status = 1;
                            context.read<HomeBloc>().add(HomeInitEvent());
                          } catch (_) {}
                        },
                        child: MainCategory(
                          title: pending,
                          icon: 'assets/icons_svg/received.svg',
                          length: UserToken.pendingTask,
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(5)
                              .copyWith(topLeft: const Radius.circular(20)),
                        ),
                      );
                    },
                  ),
                  DragTarget<LeadCard>(
                    onAccept: (object) {
                      try {
                        context.read<HomeBloc>().add(LeadsUpdateEvent(
                          id: object.lead.id,
                          project_id: object.lead.projectId,
                          contact_id: object.lead.contactId ?? null,
                          start_date: object.lead.startDate,
                          end_date: object.lead.endDate,
                          estimated_amount: object.lead.estimatedAmount,
                          lead_status: 2,
                          seller_id: object.lead.seller_id,
                          description: object.lead.description,
                          currency: object.lead.currency,
                        ));
                      } catch (_) {}
                    },
                    builder: (context, object, list) {
                      return GestureDetector(
                        onTap: () {
                          try {
                            HomePage.lead_status = 2;
                            context.read<HomeBloc>().add(HomeInitEvent());
                          } catch (_) {}
                        },
                        child: MainCategory(
                          title: inProgress,
                          icon: 'assets/icons_svg/in_progress.svg',
                          length: UserToken.inProgressTask,
                          color: AppColors.mainYellow,
                          borderRadius: BorderRadius.circular(5).copyWith(
                            topRight: const Radius.circular(20),
                          ),
                        ),
                      );
                    },
                  ),
                  DragTarget<LeadCard>(
                    onAccept: (object) {
                      try {
                        context.read<HomeBloc>().add(LeadsUpdateEvent(
                          id: object.lead.id,
                          project_id: object.lead.projectId,
                          contact_id: object.lead.contactId ?? null,
                          start_date: object.lead.startDate,
                          end_date: object.lead.endDate,
                          estimated_amount: object.lead.estimatedAmount,
                          lead_status: 10,
                          seller_id: object.lead.seller_id,
                          description: object.lead.description,
                          currency: object.lead.currency,
                        ));
                      } catch (_) {}
                    },
                    builder: (context, object, list) {
                      return GestureDetector(
                        onTap: () {
                          try {
                            HomePage.lead_status = 10;
                            context.read<HomeBloc>().add(HomeInitEvent());
                          } catch (_) {}
                        },
                        child: MainCategory(
                          title: completed,
                          icon: 'assets/icons_svg/completed.svg',
                          length: UserToken.completedTask,
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(5).copyWith(
                            bottomLeft: const Radius.circular(20),
                          ),
                        ),
                      );
                    },
                  ),
                  DragTarget<LeadCard>(
                    onAccept: (object) {
                      try {
                        context.read<HomeBloc>().add(LeadsUpdateEvent(
                          id: object.lead.id,
                          project_id: object.lead.projectId,
                          contact_id: object.lead.contactId ?? null,
                          start_date: object.lead.startDate,
                          end_date: object.lead.endDate,
                          estimated_amount: object.lead.estimatedAmount,
                          lead_status: 3,
                          seller_id: object.lead.seller_id,
                          description: object.lead.description,
                          currency: object.lead.currency,
                        ));
                      } catch (_) {}
                    },
                    builder: (context, object, list) {
                      return GestureDetector(
                        onTap: () {
                          try {
                            HomePage.lead_status = 3;
                            context.read<HomeBloc>().add(HomeInitEvent());
                          } catch (_) {}
                        },
                        child: MainCategory(
                          title: canceled,
                          icon: 'assets/icons_svg/canceled.svg',
                          length: UserToken.canceledTask,
                          color: Color(0xffFF6157),
                          borderRadius: BorderRadius.circular(5)
                              .copyWith(
                              bottomRight: const Radius.circular(20)),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
