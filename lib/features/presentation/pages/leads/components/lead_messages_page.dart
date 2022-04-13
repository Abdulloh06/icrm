import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/service/sms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/models/message_model.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../blocs/lead_messages_bloc/lead_messages_bloc.dart';
import '../../../blocs/lead_messages_bloc/lead_messages_event.dart';
import '../../../blocs/lead_messages_bloc/lead_messages_state.dart';

class LeadMessagesPage extends StatefulWidget {
  const LeadMessagesPage({
    Key? key,
    required this.lead,
  }) : super(key: key);

  final LeadsModel lead;

  @override
  State<LeadMessagesPage> createState() => _LeadMessagesPageState();
}

class _LeadMessagesPageState extends State<LeadMessagesPage> {


  final _smsService = SMSService();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
      child: BlocBuilder<LeadMessageBloc, LeadMessagesState>(
          builder: (context, leadMessage) {
            if (leadMessage is LeadMessagesInitState) {

              List<MessageModel> messages = leadMessage.messages;

              return Scaffold(
                backgroundColor: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
                body: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView.separated(
                    itemCount: messages.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment:
                        messages[index].user_id ==
                            null ? MainAxisAlignment.start : MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
                            ),
                            child: Text(leadMessage.messages[index].message),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: UserToken.isDark
                          ? AppColors.mainDark
                          : Color.fromRGBO(
                          241, 244, 247, 1),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: TextField(
                      cursorColor: AppColors.mainColor,
                      controller: controller,
                      decoration: InputDecoration(
                        prefixIcon: CircleAvatar(
                          backgroundColor: Color.fromRGBO(
                              220, 223, 227, 1),
                          child: SvgPicture.asset(
                            'assets/icons_svg/clip.svg',
                            height: 14,
                          ),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        hintText: Locales.string(
                          context, 'write_message',
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            if(controller.text.isNotEmpty) {
                              await _smsService.sendSMS(
                                phone: widget.lead.contact!
                                    .phone_number,
                                message: controller.text,
                              );
                              context.read<LeadMessageBloc>().add(
                                LeadMessagesSendEvent(
                                  lead_id: widget.lead.id,
                                  message: controller.text,
                                  user_id: widget.lead.createdBy,
                                  client_id: null,
                                ),
                              );
                              controller.clear();
                              setState(() {});
                            }
                          },
                          child: SvgPicture.asset(
                              'assets/icons_svg/send.svg'),
                        ),
                      ),
                    ),
                  ),
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
