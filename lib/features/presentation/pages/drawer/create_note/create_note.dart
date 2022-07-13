/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_bloc.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_event.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_state.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_event.dart';
import 'package:icrm/features/presentation/pages/profile/pages/notes/my_notes.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

class CreateNote extends StatefulWidget {
  CreateNote({
    Key? key,
    this.isSubNote = false,
    this.title = '',
    this.fromNotes = true,
    this.id = 0,
    this.description = '',
  }) : super(key: key);

  final bool isSubNote;
  final String title;
  final String description;
  final int id;
  final bool fromNotes;

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {

  final _imagePicker = ImagePicker();
  List<String> images = [];
  bool isListening = false;
  int length = 0;

  final _speech = SpeechToText();

  void pickImage() async {
    if (images.length < 5 && length < 5) {
      try {
        final image = await _imagePicker.pickImage(source: ImageSource.gallery);
        if(image != null) {
          setState(() {
            images.add(image.path);
          });
          if(widget.isSubNote) {
            context.read<AttachmentBloc>().add(AttachmentAddEvent(
              content_id: widget.id,
              content_type: "note",
              file: File(image.path),
            ));
          }
        }

      } catch (error) {
        print(error);
      }
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          duration: Duration(seconds: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          backgroundColor: AppColors.redLight,
          content: LocaleText('max_photo_length',
              style: AppTextStyles.mainGrey.copyWith(color: AppColors.red)),
        ),
      );
    }
  }

  void listen() async {
    if(!isListening) {
      bool available = await _speech.initialize(
        onStatus: (value) => print(value),
        onError: (error) => print('Error: $error'),
        debugLogging: true,
      );
      if(available) {
        setState(() {
          isListening = true;
        });
        _speech.listen(
          onResult: (value) => setState(() {
            _descriptionController.text = value.recognizedWords;
          }),
        );
      }

    } else {
      setState(() {
        isListening = false;
      });
      _speech.stop();
    }
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.isSubNote) {
      context.read<AttachmentBloc>().add(AttachmentShowEvent(
        content_type: "note",
        content_id: widget.id,
      ));
      _titleController.text = widget.title;
      _descriptionController.text = widget.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: '',
          titleWidget: IconButton(
            splashRadius: _titleController.text != '' && _descriptionController.text != '' ? 25 : 0.1,
            onPressed: () {
              if(_titleController.text != '' && _descriptionController.text != '') {
                if(widget.isSubNote) {
                  context.read<NotesBloc>().add(
                    NotesUpdateEvent(
                      id: widget.id,
                      content: _descriptionController.text,
                      title: _titleController.text,
                    ),
                  );
                } else {
                  context.read<NotesBloc>().add(
                    NotesAddEvent(
                      title: _titleController.text,
                      content: _descriptionController.text,
                      images: images,
                    ),
                  );
                }
                if(widget.fromNotes) {
                  Navigator.pop(context);
                }else {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MyNotes()));
                }
              }
            },
            icon: Icon(Icons.check, color: _titleController.text != '' && _descriptionController.text != '' ? UserToken.isDark ? Colors.white : Colors.black : AppColors.greyDark,),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                cursorColor: AppColors.mainColor,
                style: TextStyle(fontSize: 24, color: AppColors.greyDark),
                decoration: InputDecoration(
                  hintText: Locales.string(context, 'header'),
                  hintStyle: TextStyle(fontSize: 24, color: AppColors.greyDark),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() {}),
              ),
              TextField(
                maxLines: 12,
                controller: _descriptionController,
                cursorColor: AppColors.mainColor,
                style: TextStyle(color: AppColors.greyDark),
                decoration: InputDecoration(
                  hintText: Locales.string(context, 'start_write'),
                  hintStyle: TextStyle(color: AppColors.greyDark),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() {}),
              ),
              const Spacer(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
                child: Builder(
                  builder: (context) {
                    if(widget.isSubNote) {
                      return BlocBuilder<AttachmentBloc, AttachmentState>(
                        builder: (context, state) {
                          if(state is AttachmentShowState) {
                            length = state.documents.length;
                            return Visibility(
                              visible: state.documents.isNotEmpty,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: state.documents.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: CachedNetworkImage(
                                      imageUrl: state.documents[index].path,
                                      errorWidget: (context, error, stacktrace) {
                                        return SizedBox();
                                      },
                                      placeholder: (context, progress) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.mainColor,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          }else {
                            return Loading();
                          }
                        },
                      );
                    }else {
                      return Visibility(
                        visible: images.isNotEmpty,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Image.file(File(images[index]));
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AvatarGlow(
            animate: isListening,
            endRadius: 40,
            glowColor: AppColors.mainColor,
            child: GestureDetector(
              onTap: () => listen(),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: SvgPicture.asset('assets/icons_svg/microphone.svg'),
                radius: 30.0,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => pickImage(),
            child: SvgPicture.asset('assets/icons_svg/image.svg'),
          ),
        ],
      ),
    );
  }
}
