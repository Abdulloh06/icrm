/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../core/util/colors.dart';
import '../../../blocs/home_bloc/home_bloc.dart';
import '../../../blocs/home_bloc/home_event.dart';
import '../../leads/components/lead_card.dart';
import '../../leads/pages/leads_page.dart';
import '../pages/home_page.dart';

class LeadsList extends StatefulWidget {
  const LeadsList({
    Key? key,
    required this.state,
  }) : super(key: key);
  
  final HomeInitState state;

  @override
  State<LeadsList> createState() => _LeadsListState();
}

class _LeadsListState extends State<LeadsList> {
  
  final _downController = RefreshController();

  List<StatusModel> visibleStatuses = [];

  @override
  void initState() {
    super.initState();
    visibleStatuses = widget.state.leadStatus.where((element) => element.userLabel != null).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: widget.state.leads.length > 14 && !HomeGetNextPageEvent.hasReachedMax,
      onLoading: () {
        print("REFRESH LOADING");
        context.read<HomeBloc>().add(HomeGetNextPageEvent(leads: widget.state.leads));
        _downController.loadComplete();
        setState(() {});
      },
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
      controller: _downController,
      child: Builder(
        builder: (context) {
          if (widget.state.leads.isNotEmpty) {
            return ListView.builder(
              itemCount: widget.state.leads.length,
              itemBuilder: (context, index) {
                return Visibility(
                    visible: HomePage.lead_status != null
                        ? widget.state.leads[index].leadStatusId ==
                        HomePage.lead_status
                        : true,
                    child: LongPressDraggable<LeadCard>(
                      data: LeadCard(
                        lead: widget.state.leads[index],
                      ),
                      feedback: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 0,
                        type: MaterialType.card,
                        child: Container(
                          height: 130,
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.only(
                              left: 20, right: 20),
                          child: LeadCard(
                            isDragging: true,
                            lead: widget.state.leads[index],
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeadsPage(
                                lead: widget.state.leads[index],
                                leadStatuses: visibleStatuses,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: LeadCard(
                            onMessageTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeadsPage(
                                    lead: widget.state.leads[index],
                                    leadStatuses: visibleStatuses,
                                    toMessage: true,
                                  ),
                                ),
                              );
                            },
                            lead: widget.state.leads[index],
                          ),
                        ),
                      ),
                      childWhenDragging: SizedBox(
                        height: 175,
                      ),
                    ),
                  );
              },
            );
          } else if (widget.state.leads.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/png/empty.png',
                  color: UserToken.isDark ? Colors.white : Colors.black,
                ),
                LocaleText(
                  "unfortunately_nothing_yet",
                  style: TextStyle(
                    color: UserToken.isDark ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ],
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
