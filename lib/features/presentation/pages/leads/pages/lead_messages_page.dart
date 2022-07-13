/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/message_model.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/lead_messages_bloc/lead_messages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import '../../../../../core/repository/api_repository.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
import '../../../../../core/util/text_styles.dart';
import '../../../blocs/lead_messages_bloc/lead_messages_bloc.dart';
import '../../../blocs/lead_messages_bloc/lead_messages_event.dart';

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

  final controller = TextEditingController();
  final _scrollController = ScrollController();
  List<MessageModel> messages = [];
  late final TeleDart _teleDart;

  _setTelegram() async {
    final username = (await Telegram(ApiRepository.botToken).getMe()).username;
    _teleDart = TeleDart(ApiRepository.botToken, Event(username!));
  }

  void _sendMessage() async {
    if(controller.text.isNotEmpty
        && widget.lead.seller_id == UserToken.id) {
      if(widget.lead.contact!.telegramId != null) {
        context.read<LeadMessageBloc>().add(
          LeadMessagesSendEvent(
            lead_id: widget.lead.id,
            message: controller.text,
            user_id: widget.lead.seller_id,
            client_id: null,
          ),
        );
        await _teleDart.sendMessage(
          widget.lead.contact!.telegramId,
          widget.lead.project!.name + ":" + "\n\n" + controller.text,
        );
        messages = messages.reversed.toList();
        messages.add(MessageModel(
          id: 0,
          lead_id: widget.lead.id,
          client_id: null,
          message: controller.text,
          user_id: widget.lead.seller_id,
          created_at: DateTime.now().toString(),
          updated_at: "",
        ));
        messages = messages.reversed.toList();
        controller.clear();
        setState(() {});
      }else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(20),
            backgroundColor: AppColors.mainColor,
            content: LocaleText("client_did_not_start_the_bot", style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
          ),
        );
      }

    }else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(20),
          backgroundColor: AppColors.mainColor,
          content: LocaleText("you_are_not_seller", style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeInitEvent());
    _setTelegram();
    FirebaseMessaging.onMessage.listen((message) {
      if(message.data['endpoint'] == "lead-messages") {
        print("LEAD MESSAGE");
        context.read<LeadMessageBloc>().add(GetMessageFromNotification(
          id: int.parse(message.data['id'].toString()),
          leadId: widget.lead.id,
          clientId: widget.lead.contactId,
          message: message.notification!.body.toString(),
          messages: messages,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
      ),
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10),
      child: BlocBuilder<LeadMessageBloc, LeadMessagesState>(
          builder: (context, state) {
            if(state is LeadMessagesInitState) {
              messages = state.messages.reversed.toList();
            }
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: ListView.separated(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          String time = DateFormat("Hm").format(DateTime.parse(messages[index].created_at)).toString();
                          return Row(
                            mainAxisAlignment: messages[index].user_id == null
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width / 1.5,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: UserToken.isDark ? AppColors.cardColorDark : Color.fromRGBO(
                                        241, 244, 247, 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            messages[index].message,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          time,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 46,
                  margin: const EdgeInsets.symmetric(horizontal: 5).copyWith(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: UserToken.isDark
                        ? AppColors.mainDark
                        : AppColors.textFieldColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    cursorColor: AppColors.mainColor,
                    controller: controller,
                    onChanged: (value) {},
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      prefixIcon: CircleAvatar(
                        backgroundColor: Color.fromRGBO(
                          220, 223, 227, 1,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons_svg/clip.svg',
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: Locales.string(
                        context, 'write_message',
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => _sendMessage(),
                        child: SvgPicture.asset(
                          'assets/icons_svg/send_lead_message.svg',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}
