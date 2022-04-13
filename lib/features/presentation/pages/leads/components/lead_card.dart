/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/contacts_model.dart';
import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import 'package:flutter_locales/flutter_locales.dart';

class LeadCard extends StatelessWidget{
  LeadCard({
    Key? key,
    required this.lead,
    this.fromProject = false,
    this.contact,
    this.isDragging = false,
    this.onMessageTap,
  }) : super(key: key);

  final LeadsModel lead;
  final bool fromProject;
  final ContactModel? contact;
  final bool isDragging;
  final VoidCallback? onMessageTap;

  @override
  Widget build(BuildContext context) {

    String start_date;
    String deadline;

    try {
      start_date = DateFormat("dd.MM.yyyy").format(DateTime.parse(lead.startDate));
      deadline = DateFormat("dd.MM.yyyy").format(DateTime.parse(lead.endDate));
    } catch(error) {
      start_date = lead.startDate;
      deadline = lead.endDate;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: isDragging ? 6 : 10,
            height: isDragging ? 100 : 175,
            decoration: BoxDecoration(
              color: lead.leadStatus != null ? Color(int.parse(lead.leadStatus!.color.split('#').join('0xff'))) : AppColors.mainColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: isDragging ? 110 : 175,
              decoration: BoxDecoration(
                color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        if(lead.contact != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      lead.contact!.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.apText.copyWith(
                                        fontSize: isDragging ? 12 : 18,
                                        color: UserToken.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      if(lead.member != null) {
                                        return SvgPicture.asset('assets/icons_svg/dot.svg');
                                      }else {
                                        return Row(
                                          children: [
                                            MainButton(
                                              onTap: () {
                                                context.read<HomeBloc>().add(LeadsUpdateEvent(
                                                  id: lead.id,
                                                  project_id: lead.projectId,
                                                  contact_id: lead.contactId,
                                                  start_date: lead.startDate,
                                                  end_date: lead.endDate,
                                                  estimated_amount: lead.estimatedAmount,
                                                  lead_status: lead.leadStatusId,
                                                  seller_id: UserToken.id,
                                                ),);
                                              },
                                              color: AppColors.mainColor,
                                              title: 'receive',
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              borderRadius: 5,
                                            ),
                                            const SizedBox(width: 8),
                                            SvgPicture.asset(
                                              "assets/icons_svg/menu_icon.svg",
                                              color: AppColors.greyDark,
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                lead.project!.name,
                                style: AppTextStyles.apText.copyWith(
                                  fontSize: isDragging ? 8 : 12,
                                  color: UserToken.isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async{
                                          final Uri _emailLaunchUri = Uri(
                                            scheme: 'mailto',
                                            path: lead.contact!.email,
                                          );
                                          await launch(_emailLaunchUri.toString());
                                        },
                                        child: Text(
                                          "@Email",
                                          style: TextStyle(
                                            fontSize: isDragging ? 8 : 14,
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      SvgPicture.asset('assets/icons_svg/dottt.svg'),
                                      const SizedBox(width: 5),
                                      Text(
                                        lead.contact!.phone_number,
                                        style: TextStyle(
                                          fontSize: isDragging ? 8 : 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Builder(
                                      builder: (context) {
                                        if(lead.estimatedAmount.toString() != 'null') {
                                          return Text(
                                            lead.estimatedAmount.toString() + " " + lead.currency.toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: isDragging ? 12 : 24,
                                              color: UserToken.isDark ? Colors.white : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            "",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: isDragging ? 12 : 24,
                                              color: UserToken.isDark ? Colors.white : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  Locales.string(context, 'no_contact_info'),
                                  style: TextStyle(
                                    fontSize: isDragging ? 6 : 12,
                                    color: UserToken.isDark
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              SvgPicture.asset("assets/icons_svg/dot.svg"),
                            ],
                          );
                        }
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: !isDragging,
                          child: Builder(
                            builder: (context) {
                              if(lead.messages!.isNotEmpty) {
                                return Text(
                                  lead.messages!.first.message,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10),
                                );
                              }else {
                                return SizedBox(height: 1);
                              }
                            },
                          ),
                          replacement: SizedBox(height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons_svg/calen.svg',
                                  height: isDragging ? 15 : 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  start_date.toString() + " - " + deadline.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: isDragging ? 8 : 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await launch('tel: ${lead.contact!.phone_number}');
                                  },
                                  child: Container(
                                    height: isDragging ? 20 : 32,
                                    width: isDragging ? 20 : 32,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.greyText,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons_svg/call.svg',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                GestureDetector(
                                  onTap: onMessageTap,
                                  child: Container(
                                    height: isDragging ? 20 : 32,
                                    width: isDragging ? 20 : 32,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.greyText,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                          'assets/icons_svg/mess.svg'),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
