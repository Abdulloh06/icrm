import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/features/presentation/pages/tasks/components/priority.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../../../../../../core/util/colors.dart';
import '../../../../../blocs/tasks_bloc/tasks_bloc.dart';

class PriorityPopUp extends StatefulWidget {
  const PriorityPopUp({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TasksModel task;

  @override
  State<PriorityPopUp> createState() => _PriorityPopUpState();
}

class _PriorityPopUpState extends State<PriorityPopUp> {
  late int priority;
  
  @override
  void initState() {
    super.initState();
    priority = widget.task.priority;
  }
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (index) {
        setState(() {
          priority = index;
        });
        context.read<TasksBloc>().add(
          TasksUpdateEvent(
            id: widget.task.id,
            name: widget.task.name,
            start_date: widget.task.startDate,
            deadline: widget.task.deadline,
            priority: index,
            description: widget.task.description,
            status: widget.task.taskStatusId,
            parent_id: widget.task.parentId,
            taskType: widget.task.taskType,
            taskId: widget.task.taskId,
          ),
        );
      },
      offset: Offset(
        MediaQuery.of(context).size.width / 1,
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      color: Colors.transparent,
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 1,
            height: 30,
            child: Priority(
              text: 'urgent',
              textColor: AppColors.red,
              backgroundColor: AppColors.redLight,
            ),
          ),
          PopupMenuItem(
            value: 2,
            height: 30,
            child: Priority(
              text: 'important',
              textColor: AppColors.mainColor,
              backgroundColor: Color(0xfffDFDAF4),
            ),
          ),
          PopupMenuItem(
            value: 9,
            height: 30,
            child: Priority(
              text: 'normal',
              textColor: AppColors.green,
              backgroundColor: AppColors.greenLight,
            ),
          ),
          PopupMenuItem(
            height: 30,
            value: 10,
            child: Priority(
              text: 'low',
              textColor: AppColors.greyDark,
              backgroundColor:
              AppColors.greyDark.withOpacity(0.1),
            ),
          ),
        ];
      },
      child: Container(
        height: 28,
        width: 105,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: priority == 1
              ? Color.fromARGB(255, 255, 223, 221)
              : priority == 2
              ? Color(0xffDFDAF4)
              : priority == 9
              ? Color.fromARGB(255, 223, 244, 228)
              : AppColors.greyDark.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          priority == 1
              ? Locales.string(context, 'urgent')
              : priority == 2
              ? Locales.string(context, 'important')
              : priority == 9
              ? Locales.string(context, 'normal')
              : Locales.string(context, 'low'),
          style: TextStyle(
            fontSize: 10,
            color: priority == 1
                ? AppColors.red
                : priority == 2
                ? AppColors.mainColor
                : priority == 9
                ? AppColors.green
                : AppColors.greyDark,
          ),
        ),
      ),
    );
  }
}
