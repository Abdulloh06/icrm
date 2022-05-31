import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/models/projects_model.dart';
import '../../../../../core/models/status_model.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../project/pages/project_structe.dart';

class SearchProjects extends StatelessWidget {
  const SearchProjects({
    Key? key,
    required this.search,
    required this.projects,
    required this.projectStatuses,
  }) : super(key: key);

  final String search;
  final List<ProjectsModel> projects;
  final List<StatusModel> projectStatuses;
  
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
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectStructure(
                    project: projects[index],
                    projectStatus: projectStatuses,
                  ))),
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
                ),
              );
            },
          );
        } else {
          return Center(
            child: LocaleText('empty', style: AppTextStyles.mainGrey),
          );
        }
      },
    );
  }
}
