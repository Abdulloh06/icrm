/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/features/presentation/blocs/lead_messages_bloc/lead_messages_state.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../core/repository/user_token.dart';
import '../../../../../core/util/colors.dart';
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

  @override
  void initState() {
    super.initState();
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
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: state.messages.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            String time = DateFormat("Hm").format(DateTime.parse(state.messages[index].created_at)).toString();
                            return Row(
                              mainAxisAlignment: state.messages[index].user_id == null
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: UserToken.isDark ? AppColors.cardColorDark : Color.fromRGBO(
                                      241, 244, 247, 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        state.messages[index].message,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        time,
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
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
                          onTap: () {
                            if(controller.text.isNotEmpty) {
                              context.read<LeadMessageBloc>().add(
                                LeadMessagesSendEvent(
                                  lead_id: widget.lead.id,
                                  message: controller.text,
                                  user_id: widget.lead.seller_id,
                                  client_id: null,
                                ),
                              );
                              controller.clear();
                              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                              setState(() {});
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/icons_svg/send_lead_message.svg',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }else {
              return Loading();
            }
          }
      ),
    );
  }
}
