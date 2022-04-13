import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:icrm/features/presentation/pages/tasks/components/tasks_card.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/selected_tasks.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/text_styles.dart';
import '../../tasks/pages/create_task.dart';

class LeadTasks extends StatelessWidget {
  const LeadTasks({
    Key? key,
    required this.id,
    required this.tasks,
  }) : super(key: key);

  final int id;
  final List<TasksModel> tasks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTask(
                    fromTask: false,
                    task_id: id,
                    task_type: 'lead',
                  ),
                ),
              );
            },
            child: Row(
              children: [
                LocaleText(
                  'add',
                  style: AppTextStyles.mainBold
                      .copyWith(
                    color: UserToken.isDark
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
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                if(state is TasksInitState) {
                  return Builder(
                    builder: (context) {
                      if(tasks.isNotEmpty) {
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                            childAspectRatio: 1.05,
                          ),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return TasksCard(
                              status: tasks[index].taskStatus!,
                              task: tasks[index],
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage(
                                  task: tasks[index],
                                  taskStatuses: state.tasksStatuses,
                                )));
                              },
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: LocaleText('empty'),
                        );
                      }
                    }
                  );
                }else {
                  return Loading();
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}
