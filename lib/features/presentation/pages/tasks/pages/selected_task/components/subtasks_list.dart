import 'package:icrm/core/models/tasks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../core/repository/user_token.dart';
import '../../../../../../../core/util/text_styles.dart';
import '../../../components/subtasks_card.dart';
import '../../create_task.dart';

class SubtasksList extends StatelessWidget {
  const SubtasksList({
    Key? key,
    required this.taskId,
    required this.parentId,
    required this.subtasks,
  }) : super(key: key);

  final List<TasksModel> subtasks;
  final int parentId;
  final int taskId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20)
          .copyWith(top: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTask(
                        parent_id: parentId,
                        task_type: 'user',
                        fromTask: false,
                        task_id: taskId,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    LocaleText(
                      'add',
                      style: AppTextStyles
                          .mainBold
                          .copyWith(
                        color: UserToken
                            .isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                        'assets/icons_svg/add_yellow.svg'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Builder(
                builder: (context) {
                  if(subtasks.isNotEmpty) {
                    return ListView.builder(
                      itemCount: subtasks.length,
                      itemBuilder: (context, index) {
                        List<String> assigns = [];
                        if(subtasks[index].members != null) {
                          for(int i = 0; i < subtasks[index].members!.length; i++) {
                            assigns.add(subtasks[index].members![i].social_avatar.toString());
                          }
                        }
                        return Subtask(
                          name: subtasks[index].name,
                          assigns: assigns,
                        );
                      },
                    );
                  }else {
                    return Center(
                      child: LocaleText('empty'),
                    );
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}
