import 'package:icrm/features/presentation/blocs/home_bloc/home_state.dart';
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
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: !HomeGetNextPageEvent.hasReachedMax,
        onLoading: () {
          print("REFRESH LOADING");
          context.read<HomeBloc>().add(HomeGetNextPageEvent(leads: widget.state.leads));
          _downController.loadComplete();
          setState(() {});
        },
        footer: CustomFooter(
          builder: (context, status) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
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
                            height: 125,
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
                                  phone_number: widget.state.leads[index].contact != null ? widget.state.leads[index].contact!.phone_number : "",
                                  leadStatuses: widget.state.leadStatus,
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
                                      phone_number: widget.state.leads[index].contact != null ? widget.state.leads[index].contact!.phone_number : "",
                                      leadStatuses: widget.state.leadStatus,
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
                  });
            } else if (widget.state.leads.isEmpty) {
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
    );
  }
}
