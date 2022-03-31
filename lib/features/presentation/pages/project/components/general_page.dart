import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/company_bloc/company_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:avlo/features/presentation/pages/project/components/main_info_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../widgets/main_button.dart';

class GeneralPage extends StatefulWidget {
  GeneralPage({
    Key? key,
    required this.company_id,
    required this.id,
  }) : super(key: key);

  final int company_id;
  final int id;

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {


  final _descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    context.read<CompanyBloc>().add(CompanyShowEvent(id: widget.company_id));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<ProjectsBloc, ProjectsState>(builder: (context, project) {
        if (project is ProjectsShowState) {
          _descriptionController.text = project.project.description;
          return Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton(
                    color: Colors.transparent,
                    elevation: 0,
                    itemBuilder: (context) {
                      return List.generate(project.projectsStatuses.length,
                              (index) {
                            return PopupMenuItem(
                              onTap: () {
                                context.read<ProjectsBloc>().add(
                                  ProjectsUpdateEvent(
                                    id: project.project.id,
                                    name: project.project.name,
                                    description: project.project.description,
                                    project_status_id: project.projectsStatuses[index].id,
                                    user_category_id: project.project.user_category_id,
                                    company_id: project.project.company_id,
                                  ),
                                );
                              },
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5)
                                    .copyWith(left: 16, right: 9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(int.parse(project
                                      .projectsStatuses[index].color
                                      .split('#')
                                      .join('0xff'))),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  project.projectsStatuses[index].name,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      padding: const EdgeInsets.symmetric(vertical: 5)
                          .copyWith(left: 16, right: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(int.parse(project
                            .project.projectStatus!.color
                            .split('#')
                            .join('0xff'))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            project.project.projectStatus!.name,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 30),
                          SvgPicture.asset(
                            'assets/icons_svg/menu_icon.svg',
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: UserToken.isDark
                        ? AppColors.cardColorDark
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      BlocBuilder<CompanyBloc, CompanyState>(
                          builder: (context, state) {
                        if (state is CompanyShowState) {
                          return Container(
                            margin: EdgeInsets.only(left: 15, right: 7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    LocaleText(
                                      'company',
                                      style: AppTextStyles.apText.copyWith(
                                          color: UserToken.isDark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SingleChildScrollView(
                                              child: MainInfoDialog(
                                                projectId: project.project.id,
                                                contact_id: state.company.contact_id,
                                                company_id: state.company.id,
                                                contact: state.company.contact,
                                                companyName: state.company.name,
                                                projectName: project.project.name,
                                                contactName: state.company.contact != null ? state.company.contact!.name : "",
                                                logo: state.company.logo,
                                                url: state.company.site_url,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: SvgPicture.asset(
                                          "assets/icons_svg/notes.svg"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      Locales.string(context, 'logo_short') + ":",
                                      style: AppTextStyles.aappText
                                          .copyWith(color: UserToken.isDark ? Colors.white : Colors.black),
                                    ),
                                    const SizedBox(width: 20),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15),
                                            bottom: Radius.circular(15),
                                          ),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: state.company.logo,
                                          placeholder: (context, place) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.mainColor,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                edit(
                                  type: Locales.string(context, 'name') +
                                      " " +
                                      Locales.string(context, 'companies'),
                                  value: state.company.name,
                                ),
                                edit(
                                  type: Locales.string(context, 'the_contact_person'),
                                  value: state.company.contact != null ? state.company.contact!.name : "",
                                ),
                                edit(
                                  type: Locales.string(context, 'number_phone'),
                                  value: state.company.contact != null ? state.company.contact!.phone_number : "",
                                ),
                                edit(
                                  type: "E-mail",
                                  value: state.company.contact != null ? state.company.contact!.email : "",
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          );
                        } else if (state is CompanyLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainColor,
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            height: 150,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: LocaleText(
                              'no_company_info',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: UserToken.isDark
                        ? AppColors.cardColorDark
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Locales.string(context, 'projectss'),
                                  style: AppTextStyles.apText.copyWith(
                                    color: UserToken.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isEdit = !isEdit;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                      "assets/icons_svg/notes.svg"),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Builder(
                              builder: (context) {
                                if (!isEdit) {
                                  return Text(
                                    project.project.description,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: UserToken.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15,
                                    ),
                                  );
                                } else {
                                  return TextFormField(
                                    autofocus: true,
                                    validator: (value) => value!.isEmpty
                                        ? Locales.string(
                                            context, 'must_fill_this_line')
                                        : null,
                                    controller: _descriptionController,
                                    cursorColor: AppColors.mainColor,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    onEditingComplete: () {
                                      context.read<ProjectsBloc>().add(
                                            ProjectsUpdateEvent(
                                              id: widget.id,
                                              project_status_id: project
                                                  .project.project_status_id,
                                              user_category_id: project
                                                  .project.user_category_id,
                                              description:
                                                  _descriptionController.text,
                                              company_id: widget.company_id,
                                              name: project.project.name,
                                            ),
                                          );
                                      FocusScope.of(context).unfocus();
                                    },
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: MainButton(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: project.project.share));
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(20),
                          backgroundColor: AppColors.mainColor,
                          content: LocaleText('link_copied_to_clip_board', style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
                        ),
                      );
                    },
                    padding: const EdgeInsets.all(12),
                    color: AppColors.mainColor,
                    title: 'copy_link_for_form',
                  ),
                ),
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
      }),
    );
  }
}

Widget edit({required String type, required String? value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        type + ": ",
        style: AppTextStyles.aappText
            .copyWith(color: UserToken.isDark ? Colors.white : Colors.black),
      ),
      Text(
        value == null ? "" : value,
        style: AppTextStyles.aappText2
            .copyWith(color: UserToken.isDark ? Colors.white : Colors.black),
      ),
    ],
  );
}
