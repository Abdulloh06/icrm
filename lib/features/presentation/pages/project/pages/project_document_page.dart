import 'dart:io';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_bloc.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_event.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../core/repository/user_token.dart';
import '../../profile/components/notes_card.dart';

class ProjectDocumentPage extends StatefulWidget {
  const ProjectDocumentPage({
    Key? key,
    required this.project_id,
    this.content_type = 'project',
  }) : super(key: key);

  final int project_id;
  final String content_type;
  @override
  State<ProjectDocumentPage> createState() => _ProjectDocumentPageState();
}

class _ProjectDocumentPageState extends State<ProjectDocumentPage> {

  File? file;

  void pickFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      file = File(result!.files.single.path.toString());
    });

    context.read<AttachmentBloc>().add(AttachmentAddEvent(content_id: widget.project_id, content_type: widget.content_type, file: file!));
  }

  String fileType = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => pickFile(),
                child: Row(
                  children: [
                    LocaleText(
                      'add',
                      style: AppTextStyles.mainBold.copyWith(
                        color: UserToken.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset('assets/icons_svg/add_yellow.svg'),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        fileType = '';
                        context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: widget.content_type, content_id: widget.project_id));
                      },
                      child: Text('All'),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        fileType = 'pdf';
                        context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: widget.content_type, content_id: widget.project_id));
                      },
                      child: Text('PDF'),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        fileType = 'xlsx';
                        context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: widget.content_type, content_id: widget.project_id));
                      },
                      child: Text('XLSX'),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        fileType = 'zip';
                        context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: widget.content_type, content_id: widget.project_id));
                      },
                      child: Text('ZIP'),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        fileType = 'msword';
                        context.read<AttachmentBloc>().add(AttachmentShowEvent(content_type: widget.content_type, content_id: widget.project_id));
                      },
                      child: Text('DOC'),
                    ),
                  ];
                },
                child: Row(
                  children: [
                    LocaleText('filter', style: TextStyle(color: const Color(0xff82868C)),),
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 30,
                      color: const Color(0xff82868C),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<AttachmentBloc, AttachmentState>(
              builder: (context, state) {
                if(state is AttachmentShowState && state.documents.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.documents.length,
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible: state.documents[index].file_type.toLowerCase().contains(fileType),
                        child: Container(
                          padding: const EdgeInsets.all(10).copyWith(right: 0),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: UserToken.isDark ? AppColors.cardColorDark : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: AppColors.apColor,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Text(
                                        state.documents[index].file_type.split('/').last.toUpperCase(),
                                        style: AppTextStyles.primary.copyWith(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Text(
                                            state.documents[index].file_name.split('.').first,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.mainBold.copyWith(
                                              color: UserToken.isDark ? Colors.white : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            DateFormat("dd.MM.yyyy").format(DateTime.parse(state.documents[index].created_at)),
                                            style: AppTextStyles.mainGrey.copyWith(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                itemBuilder: (context) {
                                  return [
                                    popupItem(
                                      icon: 'assets/icons_svg/change.svg',
                                      title: 'change',
                                      onTap: () {},
                                    ),
                                    popupItem(
                                      icon: 'assets/icons_svg/delete.svg',
                                      title: 'delete',
                                      onTap: () => context.read<AttachmentBloc>().add(AttachmentDeleteEvent(id: state.documents[index].id, content_id: widget.project_id, content_type: widget.content_type)),
                                    ),
                                    popupItem(
                                      icon: 'assets/icons_svg/share_note.svg',
                                      title: 'share',
                                      onTap: () {},
                                    ),
                                  ];
                                },
                                padding: const EdgeInsets.all(0),
                                icon: SvgPicture.asset('assets/icons_svg/menu_icon.svg', color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }else if(state is AttachmentShowState && state.documents.isEmpty) {
                  return Center(
                    child: LocaleText('empty'),
                  );
                }else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
