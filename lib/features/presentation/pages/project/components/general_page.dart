/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/company_bloc/company_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:icrm/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:icrm/features/presentation/pages/project/components/main_info_dialog.dart';
import 'package:icrm/widgets/assign_members.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../widgets/main_button.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({
    Key? key,
    required this.project,
    required this.projectStatus,
  }) : super(key: key);
  
  final ProjectsModel project;
  final List<StatusModel> projectStatus;

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {

  final _descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.project.description;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: widget.project.members != null && widget.project.members!.isNotEmpty ? widget.project.members!.length != 1
                              ? 108
                              : 50 : 0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.project.members!.length,
                            itemBuilder: (context, index) {
                              return CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                child: GestureDetector(
                                  onLongPress: () {
                                    List<int> users = [];
                                    for(int i = 0; i < widget.project.members!.length; i++) {
                                      users.add(widget.project.members![i].id);
                                    }
                                    users.removeWhere((element) => element == widget.project.members![index].id);
                                    context.read<ProjectsBloc>().add(
                                      ProjectsUpdateEvent(
                                        id: widget.project.id,
                                        name: widget.project.name,
                                        description: widget.project.description,
                                        project_status_id: widget.project.project_status_id,
                                        users: users,
                                      ),
                                    );
                                  },
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
                                        imageUrl: widget.project.members![index].social_avatar,
                                        fit: BoxFit.fill,
                                        errorWidget: (context, error, stack) {
                                          String name = widget.project.members![index].first_name[0];
                                          String surname = "";
                                          if(widget.project.members![index].last_name.isNotEmpty) {
                                            surname = widget.project.members![index].last_name[0];
                                          }
                                          return Center(
                                            child: Text(
                                              name + surname,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
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
                                ),
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (context) {
                              return AssignMembers(
                                id: 3,
                                project: widget.project,
                              );
                            });
                          },
                          child: SvgPicture.asset('assets/icons_svg/add_icon.svg'),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    color: Colors.transparent,
                    elevation: 0,
                    itemBuilder: (context) {
                      return List.generate(widget.projectStatus.length,
                              (index) {
                        String title, color;
                        if(widget.projectStatus[index].userLabel != null) {
                          title = widget.projectStatus[index].userLabel!.name;
                          color = widget.projectStatus[index].userLabel!.color;
                        }else {
                          title = widget.projectStatus[index].name;
                          color = widget.projectStatus[index].color;
                        }
                            return PopupMenuItem(
                              onTap: () {
                                List<int> users = [];
                                for(int i = 0; i < widget.project.members!.length; i++) {
                                  users.add(widget.project.members![i].id);
                                }
                                print(widget.project.company_id.toString() + "COMPANY");
                                context.read<ProjectsBloc>().add(
                                  ProjectsUpdateEvent(
                                    id: widget.project.id,
                                    name: widget.project.name,
                                    description: widget.project.description,
                                    project_status_id: widget.projectStatus[index].id,
                                    user_category_id: widget.project.user_category_id,
                                    company_id: widget.project.company_id,
                                    users: users,
                                  ),
                                );
                              },
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5)
                                    .copyWith(left: 16, right: 9),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(int.parse(color
                                      .split('#')
                                      .join('0xff'))),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5)
                          .copyWith(left: 16, right: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(
                          int.parse(
                            widget.project.projectStatus!.color.split('#').join('0xff'),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.project.projectStatus!.name,
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
                ],
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
                                                project: widget.project,
                                                projectId: widget.project.id,
                                                contact_id: state.company.contact_id,
                                                company_id: state.company.id,
                                                contact: state.company.contact,
                                                companyName: state.company.name,
                                                projectName: widget.project.name,
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
                                    const SizedBox(width: 15),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20,
                                      child: Container(
                                        width: double.infinity,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: state.company.logo,
                                            fit: BoxFit.fill,
                                            placeholder: (context, place) {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  color: AppColors.mainColor,
                                                ),
                                              );
                                            },
                                            errorWidget: (context, error, stack) {
                                              return Image.asset(
                                                'assets/png/default_logo.png',
                                                fit: BoxFit.fill,
                                              );
                                            },
                                          ),
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
                          return Loading();
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
                                widget.project.description,
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
                                  List<int> users = [];
                                  for(int i = 0; i < widget.project.members!.length; i++) {
                                    users.add(widget.project.members![i].id);
                                  }
                                  context.read<ProjectsBloc>().add(
                                    ProjectsUpdateEvent(
                                      id: widget.project.id,
                                      project_status_id: widget.project.project_status_id,
                                      user_category_id: widget.project.user_category_id,
                                      description:
                                      _descriptionController.text,
                                      company_id: widget.project.company_id,
                                      name: widget.project.name,
                                      users: users,
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
                  Clipboard.setData(ClipboardData(text: widget.project.share));
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
      ),
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
