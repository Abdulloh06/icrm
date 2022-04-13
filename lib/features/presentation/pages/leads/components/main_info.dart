/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/models/leads_status_model.dart';
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

class MainLeadInfo extends StatelessWidget {
  MainLeadInfo({
    Key? key,
    required this.lead,
    required this.leadStatus,
  }) : super(key: key);

  final LeadsModel lead;
  final List<LeadsStatusModel> leadStatus;

  final _dynamicLink = FirebaseDynamicLinks.instance;

  @override
  Widget build(BuildContext context) {

    String start_date = '';
    String deadline = '';

    try {
      start_date = DateFormat("dd.MM.yyyy").format(DateTime.parse(lead.startDate));
      deadline = DateFormat("dd.MM.yyyy").format(DateTime.parse(lead.endDate));
    } catch (error) {
      start_date = lead.startDate;
      deadline = lead.endDate;
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
                lead.contact != null
                    ? lead.contact!.phone_number
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
                            "/leads/${lead.id}"),
                        androidParameters: const AndroidParameters(
                          packageName: 'uz.eurosoft.icrmlead',
                          minimumVersion: 1,
                        ),
                        iosParameters: const IOSParameters(
                          bundleId: "uz.eurosoft.icrmlead",
                          minimumVersion: '2',
                        ),
                      ))
                          .then((value) {
                        return Share.share(
                            value.shortUrl.toString());
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
                                lead: lead,
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
                  if(leadStatus.indexWhere((element) => element.id == lead.leadStatusId).isNegative) {
                    return CircularProgressBar(percent: 20);
                  } else {
                    if (leadStatus.elementAt(leadStatus.indexWhere((element) => element.id == lead.leadStatusId)).sequence == 0) {
                      return CircularProgressBar(percent: 5);
                    } else if (lead.leadStatusId == leadStatus.last.id) {
                      return CircularProgressBar(percent: 100);
                    } else if(leadStatus.elementAt(leadStatus.indexWhere((element) => element.id == lead.leadStatusId)).sequence == -1) {
                      return CircularProgressBar(percent: 20);
                    } else {
                      return CircularProgressBar(
                        percent: 95 / (leadStatus.length - 1) * (leadStatus.indexWhere((element) => element.id == lead.leadStatusId) - 1),
                      );
                    }

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
                                if(lead.member != null) {
                                  return CircleAvatar(
                                    radius: 18,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: lead.member!.social_avatar,
                                        errorWidget:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/png/no_user.png');
                                        },
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
                                      lead: lead,
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(50),
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.white),
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
                  Container(
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
                        Text(
                          '${start_date} - ${deadline}',
                          style: AppTextStyles.descriptionGrey,
                        )
                      ],
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
                title: lead.contact != null
                    ? lead.contact!.name
                    : "",
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  await launch('tel: ${lead.contact != null ? lead.contact!.phone_number : ""}');
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
                    path: lead.contact!.email,
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
                  context
                      .read<HomeBloc>()
                      .add(LeadsDeleteEvent(id: lead.id));
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
                  Container(
                    width: 130,
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.greenLight,
                    ),
                    child: Text(
                      lead.project!.userCategory!.title,
                      style: TextStyle(
                        color: AppColors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {},
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
                color: Colors.transparent,
                itemBuilder: (context) {
                  return List.generate(leadStatus.length,
                          (index) {
                        return PopupMenuItem(
                          padding: const EdgeInsets.only(),
                          onTap: () {
                            context.read<HomeBloc>().add(
                              LeadsUpdateEvent(
                                id: lead.id,
                                project_id: lead.projectId,
                                contact_id: lead.contactId,
                                start_date: lead.startDate,
                                end_date: lead.endDate,
                                estimated_amount: lead.estimatedAmount,
                                lead_status: leadStatus[index].id,
                                description: lead.description,
                                seller_id: lead.seller_id,
                                currency: lead.currency,
                              ),
                            );
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(vertical: 5)
                                .copyWith(left: 20, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(
                                int.parse(leadStatus[index].color
                                    .split('#')
                                    .join('0xff')),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  leadStatus[index].name,
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
                          ),
                        );
                      });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5)
                      .copyWith(left: 20, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(
                      int.parse(lead.leadStatus!.color
                          .split('#')
                          .join('0xff')),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lead.leadStatus!.name,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
