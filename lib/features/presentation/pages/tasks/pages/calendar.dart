import 'package:avlo/core/models/tasks_model.dart';
import 'package:avlo/core/util/text_input_format.dart';
import 'package:avlo/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/main_app_bar.dart';
import '../../../../../widgets/main_button.dart';

//ignore:must_be_immutable
class TasksCalendar extends StatefulWidget {
  TasksCalendar({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TasksModel task;

  @override
  State<TasksCalendar> createState() => _TasksCalendarState();
}

class _TasksCalendarState extends State<TasksCalendar> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _timeController = TextEditingController();
  static TimeOfDay time = TimeOfDay.now();
  DateTime focusedDate = DateTime.now();
  DateTime selected_date = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  int date_id = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 0),
        child: AppBarBack(title: 'calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 23).copyWith(top: 36),
              decoration: BoxDecoration(
                color: UserToken.isDark ? AppColors.mainDark : Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios,
                          size: 21,
                        ),
                        LocaleText(
                          'back',
                          style: AppTextStyles.mainBold.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  LocaleText(
                    'calendar',
                    style: AppTextStyles.mainBold.copyWith(fontSize: 25),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 1,
                    color: Color.fromARGB(52, 0, 0, 0),
                  ),
                ],
                color: UserToken.isDark ? AppColors.mainDark : Colors.white,
              ),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            isFilled: true,
                            color: UserToken.isDark
                                ? AppColors.textFieldColorDark
                                : Colors.white,
                            borderRadius: 50,
                            iconMargin: 15,
                            inputFormatters: [dateFormat],
                            keyboardType: TextInputType.datetime,
                            controller: _startDateController,
                            suffixIcon: 'assets/icons_svg/add_grey.svg',
                            hint: 'start',
                            validator: (value) => value!.isEmpty
                                ? Locales.string(context, 'must_fill_this_line')
                                : value.length < 10
                                    ? Locales.string(
                                        context, 'enter_valid_info')
                                    : null,
                            onChanged: (value) {},
                            onTap: () {
                              setState(() {
                                date_id = 1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            onTap: () {
                              setState(() {
                                date_id = 2;
                              });
                            },
                            isFilled: true,
                            color: UserToken.isDark
                                ? AppColors.textFieldColorDark
                                : Colors.white,
                            borderRadius: 50,
                            iconMargin: 15,
                            controller: _endDateController,
                            suffixIcon: 'assets/icons_svg/add_grey.svg',
                            hint: 'end',
                            inputFormatters: [dateFormat],
                            keyboardType: TextInputType.datetime,
                            validator: (value) => value!.isEmpty
                                ? Locales.string(context, 'must_fill_this_line')
                                : value.length < 10
                                    ? Locales.string(
                                        context, 'enter_valid_info')
                                    : null,
                            onChanged: (value) {},
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TableCalendar(
                      rowHeight: 40,
                      weekendDays: [DateTime.saturday, DateTime.sunday],
                      focusedDay: focusedDate,
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
                        return isSameDay(focusedDate, date);
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
                      onDaySelected:
                          (DateTime _selectedDay, DateTime _focusedDay) {
                        setState(() {
                          focusedDate = _focusedDay;
                          selected_date = _selectedDay;

                          switch (date_id) {
                            case 1:
                              _startDateController.text =
                                  DateFormat("dd.MM.yyyy").format(_selectedDay);
                              break;
                            case 2:
                              _endDateController.text =
                                  DateFormat("dd.MM.yyyy").format(_selectedDay);
                              break;
                          }
                        });
                      },
                      lastDay: DateTime(2025),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    height: 25,
                    child: Text(
                      DateFormat.yMMMd().format(selected_date),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 47,
                    child: CustomTextField(
                      isFilled: true,
                      color: UserToken.isDark
                          ? AppColors.textFieldColorDark
                          : Colors.white,
                      borderRadius: 16,
                      iconMargin: 15,
                      controller: _timeController,
                      suffixIcon: 'assets/icons_svg/add_grey.svg',
                      readOnly: true,
                      hint: 'time',
                      validator: (value) => null,
                      onChanged: (value) {},
                      onTap: () => Navigator.push(
                        context,
                        showPicker(
                          value: time,
                          onChange: (value) {
                            setState(() {
                              time = value;
                              _timeController.text = time.format(context);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainButton(
                        borderRadius: 33,
                        color: AppColors.greyLight,
                        title: 'cancel',
                        padding: const EdgeInsets.symmetric(
                            horizontal: 37, vertical: 18),
                        onTap: () => Navigator.pop(context),
                      ),
                      MainButton(
                        borderRadius: 33,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<TasksBloc>().add(
                              TasksUpdateEvent(
                                id: widget.task.id,
                                name: widget.task.name,
                                start_date: DateFormat('dd.MM.yyyy').parse(_startDateController.text).toString(),
                                deadline: DateFormat('dd.MM.yyyy').parse(_endDateController.text).toString(),
                                priority: widget.task.priority,
                                description: widget.task.description,
                                status: widget.task.taskStatusId,
                                parent_id: widget.task.parentId,
                                taskType: widget.task.taskType.split('\\').last,
                                taskId: widget.task.taskId,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        color: AppColors.mainColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 37, vertical: 18),
                        title: 'create',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
