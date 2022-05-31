/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/features/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:icrm/features/presentation/blocs/calendar_bloc/calendar_state.dart';
import 'package:icrm/features/presentation/pages/leads/components/lead_card.dart';
import 'package:icrm/features/presentation/pages/tasks/components/gridview_tasks.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/util/colors.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {

  DateTime _focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(CalendarInitEvent(date: DateFormat("yyyy-MM-dd").format(_focusedDate)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'calendar',
          elevation: 0,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: UserToken.isDark ? AppColors.mainDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
              child: TableCalendar(
                rowHeight: 40,
                weekendDays: [DateTime.saturday, DateTime.sunday],
                focusedDay: _focusedDate,
                firstDay: DateTime(2015),
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  canMarkersOverflow: true,
                  selectedDecoration: BoxDecoration(
                    color: AppColors.mainColor,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(_focusedDate, date);
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                sixWeekMonthsEnforced: false,
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      final text = DateFormat.E().format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: day.weekday == DateTime.sunday
                                ? Colors.red
                                : Color.fromARGB(255, 0, 128, 255),
                          ),
                        ),
                      );
                    } else {
                      final text = DateFormat.E().format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 128, 255),
                          ),
                        ),
                      );
                    }
                  },
                ),
                onDaySelected: (DateTime _selectedDay, DateTime _focusedDay) {
                  setState(() {
                    _focusedDate = _focusedDay;
                    String formattedDate = DateFormat("yyyy-MM-dd").format(_focusedDay);

                    context.read<CalendarBloc>().add(CalendarInitEvent(date: formattedDate));
                  });
                },
                lastDay: DateTime(2025),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MainTabBar(
                tabs: [
                  Tab(text: Locales.string(context, 'leads')),
                  Tab(text: Locales.string(context, 'tasks')),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  if(state is CalendarInitState) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TabBarView(
                        children: [
                          Visibility(
                            replacement: Center(
                              child: LocaleText('empty'),
                            ),
                            visible: state.calendar.leads.isNotEmpty,
                            child: ListView.builder(
                              itemCount: state.calendar.leads.length,
                              itemBuilder: (context, index) {
                                return LeadCard(lead: state.calendar.leads[index]);
                              },
                            ),
                          ),
                          GridViewTasks(tasks: state.calendar.tasks),
                        ],
                      ),
                    );
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
