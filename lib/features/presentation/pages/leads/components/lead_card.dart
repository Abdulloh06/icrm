import 'package:avlo/core/models/contacts_model.dart';
import 'package:avlo/core/models/leads_model.dart';
import 'package:flutter/material.dart';
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
  }) : super(key: key);

  final LeadsModel lead;
  final bool fromProject;
  final ContactModel? contact;

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
            width: 10,
            height: 170,
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
              height: 175,
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
                                  Text(
                                    lead.contact!.name,
                                    maxLines: 2,
                                    style: AppTextStyles.apText.copyWith(
                                      color: UserToken.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  SvgPicture.asset("assets/icons_svg/dot.svg"),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                lead.project!.name,
                                style: AppTextStyles.apText.copyWith(
                                  fontSize: 12,
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
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      SvgPicture.asset('assets/icons_svg/dottt.svg'),
                                      const SizedBox(width: 5),
                                      Text(lead.contact!.phone_number),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      lead.estimatedAmount.toString() + " " +lead.currency.toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: UserToken.isDark ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                    fontSize: 14,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'last',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons_svg/calen.svg'),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  start_date.toString() + " - " + deadline.toString(),
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
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: AppColors.greyText,
                                        ),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: SvgPicture.asset(
                                          'assets/icons_svg/call.svg'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  height: 32,
                                  width: 32,
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
                                )
                              ],
                            )
                          ],
                        )
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
