import 'package:icrm/core/models/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../core/repository/user_token.dart';
import '../../../../../../../core/service/api/get_tasks.dart';
import '../../../../../../../core/util/colors.dart';
import '../../../../../../../core/util/get_it.dart';
import '../../../../../../../widgets/message_card.dart';

class TaskChat extends StatefulWidget {
  TaskChat({
    Key? key,
    required this.comments,
    required this.taskId,
  }) : super(key: key);

  final List<CommentsModel> comments;
  final int taskId;

  @override
  State<TaskChat> createState() => _TaskChatState();
}

class _TaskChatState extends State<TaskChat> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 10,
        ),
        curve: Curves.bounceIn,
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
        color: UserToken.isDark
            ? AppColors.mainDark
            : Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.comments.length,
                itemBuilder:
                    (context, index) {
                  return MessageCard(
                    parent_id: widget.comments[index].parent_id,
                    job: UserToken.responsibility,
                    name: UserToken.name,
                    userPhoto: UserToken.userPhoto,
                    id: widget.comments[index].id,
                    date: widget.comments[index].created_at,
                    message: widget.comments[index].content,
                  );
                },
              ),
            ),
          ),
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
              controller: _messageController,
              cursorColor: AppColors.mainColor,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isCollapsed: true,
                prefixIcon: CircleAvatar(
                  backgroundColor: Color.fromRGBO(220, 223, 227, 1),
                  child: SvgPicture.asset(
                    'assets/icons_svg/clip.svg',
                  ),
                ),
                border: InputBorder.none,
                hintText: Locales.string(
                  context,
                  'write_message',
                ),
                suffixIcon: GestureDetector(
                  onTap: () async {
                    if (_messageController.text.isNotEmpty) {
                      try {
                        CommentsModel result = await getIt.get<GetTasks>().addComment(
                          id: widget.taskId,
                          comment: _messageController.text,
                          comment_type: 'text',
                        );

                        setState(() {
                          widget.comments.add(result);
                        });
                        FocusScope.of(context).unfocus();
                        _messageController.clear();
                      } catch (error) {
                        print(error);
                      }
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/icons_svg/send.svg',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
