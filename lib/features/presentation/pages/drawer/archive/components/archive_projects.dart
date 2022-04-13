/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/projects_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/repository/user_token.dart';
import '../../../../../../core/util/colors.dart';
import '../../../../../../core/util/text_styles.dart';

class ArchiveProjects extends StatelessWidget {
  const ArchiveProjects({
    Key? key,
    required this.projects,
    required this.search,
  }) : super(key: key);

  final List<ProjectsModel> projects;
  final String search;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(projects.isNotEmpty) {
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return Visibility(
                visible: projects[index].name.toLowerCase().contains(search.toLowerCase()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                    color: UserToken.isDark ? AppColors.mainDark : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          projects[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.proText.copyWith(
                            color: !UserToken.isDark ? AppColors.mainColor : Colors.white,
                          ),
                        ),
                      ),
                      SvgPicture.asset("assets/icons_svg/vect.svg"),
                    ],
                  ),
                ),
              );
            },
          );
        }else {
          return Center(
            child: LocaleText('empty'),
          );
        }
      },
    );
  }
}
