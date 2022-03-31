import 'package:avlo/core/models/tasks_model.dart';
import 'package:avlo/core/models/tasks_status_model.dart';
import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/pages/tasks/pages/selected_tasks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TasksCard extends StatelessWidget {
  const TasksCard({
    Key? key,
    required this.status,
    required this.task,
  });

  final TaskStatusModel status;
  final TasksModel task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskPage(
            id: task.id,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: UserToken.isDark ? [] : [
            BoxShadow(
              spreadRadius: 1.5,
              blurRadius: 1,
              color: Colors.grey.shade300,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: task.members!.length,
                    itemBuilder: (context, index) {
                      return CircleAvatar(
                        radius: 20,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: task.members![index].social_avatar,
                            errorWidget: (context, error, stack) {
                              return Image.asset('assets/png/no_user.png');
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                    height: 24,
                    width: 74,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: task.priority == 1
                          ? Color.fromARGB(255, 255, 223, 221)
                          : task.priority == 2
                          ? Color(0xffDFDAF4)
                          : task.priority == 9
                          ? Color.fromARGB(255, 223, 244, 228)
                          : AppColors.greyDark.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.priority == 1
                          ? Locales.string(context, 'urgent')
                          : task.priority == 2
                          ? Locales.string(context, 'important')
                          : task.priority == 9
                          ? Locales.string(context, 'normal')
                          : Locales.string(context, 'low'),
                      style: TextStyle(
                        fontSize: 10,
                        color: task.priority == 1
                            ? AppColors.red
                            : task.priority == 2
                            ? AppColors.mainColor
                            : task.priority == 9
                            ? AppColors.green
                            : AppColors.greyDark,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              task.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: AppTextStyles.mainBold.copyWith(
                color: UserToken.isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.descriptionGrey,
            ),
            const Spacer(),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons_svg/time.svg',
                  height: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  task.deadline,
                  style: AppTextStyles.descriptionGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
