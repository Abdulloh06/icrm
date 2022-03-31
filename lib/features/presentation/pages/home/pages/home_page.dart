import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:avlo/features/presentation/pages/home/components/main_categories.dart';
import 'package:avlo/features/presentation/pages/leads/components/lead_card.dart';
import 'package:avlo/features/presentation/pages/leads/pages/leads_page.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int? lead_status_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: MainAppBar(
          isMainColor: UserToken.isDark ? true : false,
          scaffoldKey: widget.scaffoldKey,
          elevation: 0,
          title: Text(
            'CRM',
            style: AppTextStyles.primary,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SizedBox(
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is HomeInitState) {
              return Column(
                children: [
                  Container(
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
                                  lead_status: state.dashboard[0].lead_status_id,
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
                                    lead_status_id = state.dashboard[0].lead_status_id;
                                    context.read<HomeBloc>().add(HomeInitEvent());
                                  }
                                },
                                child: MainCategory(
                                  title: 'received',
                                  icon: 'assets/icons_svg/received.svg',
                                  length: state.dashboard.isNotEmpty
                                      ? state.dashboard[0].number
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
                              if (state.dashboard.length > 1) {
                                context.read<HomeBloc>().add(LeadsUpdateEvent(
                                      id: object.lead.id,
                                      project_id: object.lead.projectId,
                                      contact_id: object.lead.contactId ?? null,
                                      start_date: object.lead.startDate,
                                      end_date: object.lead.endDate,
                                      estimated_amount:
                                          object.lead.estimatedAmount,
                                      lead_status:
                                          state.dashboard[1].lead_status_id,
                                      seller_id: object.lead.seller_id,
                                      description: object.lead.description,
                                      currency: object.lead.currency,
                                    ));
                              }
                            },
                            builder: (context, object, list) {
                              return GestureDetector(
                                onTap: () {
                                  if (state.dashboard.length > 1) {
                                    lead_status_id =
                                        state.dashboard[1].lead_status_id;
                                    context
                                        .read<HomeBloc>()
                                        .add(HomeInitEvent());
                                  }
                                },
                                child: MainCategory(
                                  title: 'in_progress',
                                  icon: 'assets/icons_svg/in_progress.svg',
                                  length: state.dashboard.length < 2
                                      ? 0
                                      : state.dashboard[1].number,
                                  color: AppColors.mainYellow,
                                  borderRadius: BorderRadius.circular(5)
                                      .copyWith(
                                          topRight: const Radius.circular(20)),
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
                                  lead_status: state.dashboard.last.lead_status_id,
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
                                    lead_status_id =
                                        state.dashboard[2].lead_status_id;
                                    context
                                        .read<HomeBloc>()
                                        .add(HomeInitEvent());
                                  }
                                },
                                child: MainCategory(
                                  title: 'completed',
                                  icon: 'assets/icons_svg/completed.svg',
                                  length: state.dashboard.last.number,
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
                                          state.dashboard[3].lead_status_id,
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
                                    lead_status_id =
                                        state.dashboard[3].lead_status_id;
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
                                      : state.dashboard[3].number,
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
                                        : Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  lead_status_id = null;
                                  context.read<HomeBloc>().add(HomeInitEvent());
                                },
                                child: Row(
                                  children: [
                                    Text(Locales.string(context, 'all')),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                        "assets/icons_svg/up_icon.svg")
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (state.leads.isNotEmpty) {
                                return ListView.builder(
                                    itemCount: state.leads.length,
                                    itemBuilder: (context, index) {
                                      return Visibility(
                                        visible: lead_status_id != null
                                            ? state.leads[index].leadStatusId ==
                                                lead_status_id
                                            : true,
                                        child: LongPressDraggable<LeadCard>(
                                          data: LeadCard(
                                            lead: state.leads[index],
                                          ),
                                          feedback: Material(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            elevation: 0,
                                            type: MaterialType.card,
                                            child: Container(
                                              height: 181,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80,
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: LeadCard(
                                                lead: state.leads[index],
                                              ),
                                            ),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              context.read<HomeBloc>().add(
                                                  LeadsShowEvent(
                                                      id: state
                                                          .leads[index].id));
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LeadsPage(
                                                        id: state.leads[index].id,
                                                        phone_number: state.leads[index].contact != null ? state.leads[index].contact!.phone_number : "",
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: LeadCard(
                                                lead: state.leads[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else if (state.leads.isEmpty) {
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
                      ],
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
          }),
        ),
      ),
    );
  }
}
