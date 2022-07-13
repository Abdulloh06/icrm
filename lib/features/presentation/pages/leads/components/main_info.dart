/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/features/presentation/blocs/lead_messages_bloc/lead_messages_bloc.dart';
import 'package:icrm/features/presentation/blocs/lead_messages_bloc/lead_messages_event.dart';
import 'package:icrm/features/presentation/pages/add_project/components/reminder_calendar.dart';
import 'package:icrm/features/presentation/pages/add_project/components/user_categories.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/models/status_model.dart';
import '../../../../../core/repository/api_repository.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../../../widgets/assign_members.dart';
import '../../../../../widgets/circular_progress_bar.dart';
import '../../../../../widgets/projects.dart';
import '../../../blocs/home_bloc/home_bloc.dart';
import '../../../blocs/home_bloc/home_event.dart';
import '../../add_project/local_pages/add_leads_page.dart';

class MainLeadInfo extends StatefulWidget {
  MainLeadInfo({
    Key? key,
    required this.lead,
    required this.leadStatus,
    this.fromProject = false,
    this.project,
  }) : super(key: key);

  final LeadsModel lead;
  final List<StatusModel> leadStatus;
  final bool fromProject;
  final ProjectsModel? project;

  static String userCategory = "";

  @override
  State<MainLeadInfo> createState() => _MainLeadInfoState();
}

class _MainLeadInfoState extends State<MainLeadInfo> {
  final _dynamicLink = FirebaseDynamicLinks.instance;
  late int leadStatusId;
  late ProjectsModel? project;

  @override
  void initState() {
    super.initState();
    leadStatusId = widget.lead.leadStatusId;
    if(widget.fromProject) {
      project = widget.project;
      if(widget.project!.userCategory != null) {
        MainLeadInfo.userCategory = widget.project!.userCategory!.title;
      }
    }else {
      if(widget.lead.project != null) {
        project = widget.lead.project;
        if(widget.lead.project!.userCategory != null) {
          MainLeadInfo.userCategory = widget.lead.project!.userCategory!.title;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    String start_date = '';
    String deadline = '';

    try {
      start_date = DateFormat("dd.MM.yyyy").format(DateTime.parse(widget.lead.startDate));
      deadline = DateFormat("dd.MM.yyyy").format(DateTime.parse(widget.lead.endDate));
    } catch (error) {
      start_date = widget.lead.startDate;
      deadline = widget.lead.endDate;
    }

    return Container(
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.mainDark : Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      padding:
      EdgeInsets.only(top: 23, right: 20, left: 20, bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.lead.contact != null
                    ? widget.lead.contact!.phone_number
                    : "",
                style: AppTextStyles.headerLeads,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 3),
                      height: 33,
                      width: 33,
                      child: Icon(
                        Icons.share,
                        size: 15,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.mainColor,
                      ),
                    ),
                    onTap: () async {
                      await _dynamicLink
                          .buildShortLink(DynamicLinkParameters(
                        uriPrefix: ApiRepository.appUrl,
                        link: Uri.parse(ApiRepository.appUrl +
                            "/leads/${widget.lead.id}"),
                        androidParameters: const AndroidParameters(
                          packageName: 'uz.eurosoft.icrmlead',
                          minimumVersion: 1,
                        ),
                        iosParameters: const IOSParameters(
                          bundleId: "uz.eurosoft.icrmlead",
                          minimumVersion: '2',
                        ),
                      )).then((value) {
                        return Share.share(value.shortUrl.toString());
                      });
                    },
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    child: SvgPicture.asset(
                      'assets/icons_svg/edit.svg',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Material(
                            child: SafeArea(
                              child: Leads(
                                fromEdit: true,
                                name: widget.fromProject ? project!.name : null,
                                lead: widget.lead,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Builder(
                builder: (context) {
                  try {
                    if (widget.leadStatus.indexWhere((element) => element.id == leadStatusId) == 0) {
                      return CircularProgressBar(percent: 5);
                    } else if (leadStatusId == widget.leadStatus.last.id) {
                      return CircularProgressBar(percent: 100);
                    } else if(widget.leadStatus.elementAt(widget.leadStatus.indexWhere((element) => element.id == leadStatusId)).id == 3) {
                      return CircularProgressBar(percent: 20);
                    } else {
                      return CircularProgressBar(
                        percent: 95 / (widget.leadStatus.length - 1) *
                            (widget.leadStatus.indexWhere(
                                    (element) => element.id == leadStatusId)),
                      );
                    }
                  } catch(e) {
                    print(e);
                    return CircularProgressBar(
                      percent: 20,
                    );
                  }
                },
              ),
              SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocaleText(
                    'team',
                    style: AppTextStyles.mainTextFont.copyWith(
                        color: UserToken.isDark
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        child: Stack(
                          children: [
                            Builder(
                              builder: (context) {
                                if(widget.lead.member != null) {
                                  return CircleAvatar(
                                    radius: 18,
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
                                          imageUrl: widget.lead.member!.social_avatar,
                                          fit: BoxFit.fill,
                                          errorWidget: (context, error, stackTrace) {
                                            String name = widget.lead.member!.first_name[0];
                                            String surname = "";
                                            if(widget.lead.member!.last_name.isNotEmpty) {
                                              surname = widget.lead.member!.last_name[0];
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
                                }else {
                                  return CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.transparent,
                                  );
                                }
                              },
                            ),
                            Positioned(
                              left: 30,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AssignMembers(
                                      id: 1,
                                      lead: widget.lead,
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(50),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons_svg/add_icon.svg',
                                    height: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ReminderCalendar(
                            id: 3,
                            fromLead: true,
                            lead: widget.lead,
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            'assets/icons_svg/calendar_bg.svg',
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Builder(
                            builder: (context) {
                              if(start_date.isEmpty) {
                                return Text(
                                  deadline,
                                  style: AppTextStyles.descriptionGrey,
                                );
                              }else if(deadline.isEmpty){
                                return Text(
                                  start_date,
                                  style: AppTextStyles.descriptionGrey,
                                );
                              }else {
                                return Text(
                                  '${start_date} - ${deadline}',
                                  style: AppTextStyles.descriptionGrey,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          LocaleText(
            'customer',
            style: AppTextStyles.mainTextFont.copyWith(
                color:
                UserToken.isDark ? Colors.white : Colors.black),
          ),
          SizedBox(height: 10),
          Wrap(
            children: [
              Projects(
                fontSize: 14,
                borderWidth: 1,
                title: widget.lead.contact != null
                    ? widget.lead.contact!.name
                    : "",
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  String phone = widget.lead.contact != null ? widget.lead.contact!.phone_number : "";

                  phone = phone.split('+').join('');
                  phone = "+" + phone;
                  if(Platform.isIOS) {
                    await launch('tel:// $phone');
                  }else {
                    await launch('tel: $phone');
                  }
                },
                child: Projects(
                  horizontalPadding: 7,
                  verticalPadding: 5,
                  widget: true,
                  borderWidth: 1,
                  title: SvgPicture.asset(
                    'assets/icons_svg/call.svg',
                    height: 15,
                    width: 11,
                    color: AppColors.greyDark,
                  ),
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () async{
                  final Uri _emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: widget.lead.contact!.email,
                  );
                  await launch(_emailLaunchUri.toString());
                },
                child: Projects(
                  borderWidth: 1,
                  verticalPadding: 7,
                  horizontalPadding: 8,
                  widget: true,
                  title: SvgPicture.asset(
                    'assets/icons_svg/mess.svg',
                    color: AppColors.greyDark,
                    height: 12,
                    width: 11,
                  ),
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(LeadsDeleteEvent(id: widget.lead.id));
                  Navigator.pop(context);
                },
                child: Projects(
                  borderWidth: 1,
                  verticalPadding: 7,
                  horizontalPadding: 8,
                  widget: true,
                  title: SvgPicture.asset(
                    'assets/icons_svg/delete.svg',
                    height: 12,
                    width: 11,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      if(project!.userCategory != null) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 130,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.greenLight,
                            ),
                            child: Text(
                              MainLeadInfo.userCategory,
                              style: TextStyle(
                                color: AppColors.green,
                              ),
                            ),
                          ),
                        );
                      }else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          scrollable: true,
                          backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          insetPadding: const EdgeInsets.only(top: 60, bottom: 60),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            width: MediaQuery.of(context).size.width - 80,
                            child: UserCategories(
                              fromProject: false,
                              project: widget.lead.project,
                            ),
                          ),
                        );
                      });
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      'assets/icons_svg/add_icon.svg',
                      height: 35,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton(
                elevation: 0,
                padding: const EdgeInsets.all(0),
                color: Colors.transparent,
                itemBuilder: (context) {
                  return List.generate(widget.leadStatus.length,
                          (index) {
                        return PopupMenuItem(
                          padding: const EdgeInsets.all(0),
                          onTap: () {
                            setState(() {
                              leadStatusId = widget.leadStatus[index].id;
                            });
                            context.read<HomeBloc>().add(
                              LeadsUpdateEvent(
                                id: widget.lead.id,
                                project_id: widget.lead.projectId,
                                contact_id: widget.lead.contactId,
                                start_date: widget.lead.startDate,
                                end_date: widget.lead.endDate,
                                estimated_amount: widget.lead.estimatedAmount,
                                lead_status: widget.leadStatus[index].id,
                                description: widget.lead.description,
                                seller_id: widget.lead.seller_id,
                                currency: widget.lead.currency,
                              ),
                            );
                            context.read<LeadMessageBloc>().add(
                              LeadMessagesSendEvent(
                                message: 'Внес изменения в статус лида',
                                client_id: null,
                                user_id: widget.lead.seller_id,
                                lead_id: widget.lead.id,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5)
                                .copyWith(left: 10, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(
                                int.parse(widget.leadStatus[index].userLabel!.color
                                    .split('#').join('0xff'),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.leadStatus[index].userLabel!.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/icons_svg/menu_icon.svg',
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Builder(
                  builder: (context) {
                    if(widget.leadStatus.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 5)
                            .copyWith(left: 15, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(
                            int.parse(
                                widget.leadStatus.elementAt(
                                    widget.leadStatus.indexWhere((element) =>
                                    element.id == leadStatusId)).userLabel!.color.split('#').join('0xff')
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.leadStatus.elementAt(
                                  widget.leadStatus.indexWhere((element) =>
                                  element.id == leadStatusId)).userLabel!.name,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            SvgPicture.asset(
                              'assets/icons_svg/menu_icon.svg',
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    }else {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 5)
                            .copyWith(left: 20, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(
                            int.parse(
                              widget.lead.leadStatus!.color.split('#').join('0xff'),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.lead.leadStatus!.name,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 30),
                            SvgPicture.asset(
                              'assets/icons_svg/menu_icon.svg',
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
