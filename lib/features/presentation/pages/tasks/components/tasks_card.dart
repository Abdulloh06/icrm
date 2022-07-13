/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/tasks_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TasksCard extends StatelessWidget {
  const TasksCard({
    Key? key,
    required this.task,
    required this.onTap,
    this.isDragging = false,
  });

  final TasksModel task;
  final VoidCallback onTap;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: UserToken.isDark ? [] : [
            BoxShadow(
              spreadRadius: 0.5,
              blurRadius: 0.5,
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
                  height: isDragging ? 25 : 35,
                  width: isDragging ? MediaQuery.of(context).size.width * 0.07 :MediaQuery.of(context).size.width * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: task.members!.isNotEmpty ? task.members!.length : 0,
                    itemBuilder: (context, index) {
                      return CircleAvatar(
                        radius: isDragging ? 15 : 20,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.grey,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: task.members![index].social_avatar,
                              fit: BoxFit.fill,
                              errorWidget: (context, error, stack) {
                                String name = task.members![index].first_name[0];
                                String surname = "";
                                if(task.members![index].last_name.isNotEmpty) {
                                  surname = task.members![index].last_name[0];
                                }
                                return Center(
                                  child: Text(
                                    name + surname,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: UserToken.isDark
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                    height: isDragging ? 16: 24,
                    width: isDragging ? 45 : 74,
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
                        fontSize: isDragging ? 5 : 10,
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
            SizedBox(height: isDragging ? 5 : 8),
            Text(
              task.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.mainBold.copyWith(
                fontSize: isDragging ? 10 : 16,
                color: UserToken.isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: isDragging ? 5 : 10),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.descriptionGrey.copyWith(
                fontSize: isDragging ? 8 : 12,
              ),
            ),
            SizedBox(height: isDragging ? 15 : 20),
            Flexible(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons_svg/time.svg',
                    height: isDragging ? 10 : 16,
                  ),
                  const SizedBox(width: 5),
                  Builder(
                    builder: (context) {
                      if(task.deadline != '') {
                        return Text(
                          DateFormat("dd.MM.yyyy").format(DateTime.parse(task.deadline)).toString(),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.descriptionGrey.copyWith(
                            fontSize: isDragging ? 8 : 12,
                          ),
                        );
                      }else {
                        return Text(
                          DateFormat("dd.MM.yyyy").format(DateTime.parse(task.startDate)).toString(),
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.descriptionGrey.copyWith(
                            fontSize: isDragging ? 8 : 12,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
