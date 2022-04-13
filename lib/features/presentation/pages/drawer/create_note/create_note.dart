/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:icrm/features/presentation/blocs/notes_bloc/notes_event.dart';
import 'package:icrm/features/presentation/pages/profile/pages/notes/my_notes.dart';
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
    this.fromNotes = true,
    this.isSubNote = false,
    this.title = '',
    this.id = 0,
    this.description = '',
  }) : super(key: key);

  final bool fromNotes;
  final bool isSubNote;
  final String title;
  final String description;
  final int id;

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {

  final _imagePicker = ImagePicker();
  List<String> images = [];
  bool isListening = false;

  final _speech = SpeechToText();

  void pickImage() async {
    if (images.length < 5) {
      try {
        final image = await _imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          images.add(image!.path);
        });

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
                    ),
                  );
                }
                if(widget.fromNotes) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyNotes()));
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
              Expanded(
                child: Visibility(
                  visible: images.isNotEmpty,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.file(File(images[index]));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            switch (index) {
              case 0:
                listen();
                break;
              case 1:
                pickImage();
                break;
              case 2:
                print(index);
                break;
              case 3:
                print(index);
                break;
            }
          },
          items: [
            item('assets/icons_svg/microphone.svg'),
            item('assets/icons_svg/image.svg'),
            item('assets/icons_svg/done.svg'),
            item('assets/icons_svg/text.svg'),
          ],
        ),
      ),
    );
  }
}

BottomNavigationBarItem item(String icon) {
  return BottomNavigationBarItem(
    icon: SvgPicture.asset(icon),
    label: '',
  );
}
