/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AttachmentEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class AttachmentShowEvent extends AttachmentEvent {
  final String content_type;
  final int content_id;

  AttachmentShowEvent({
    required this.content_type,
    required this.content_id
  });

  @override
  List<Object?> get props => [content_type, content_id];
}

class AttachmentDeleteEvent extends AttachmentEvent {
  final int id;
  final String content_type;
  final int content_id;

  AttachmentDeleteEvent({required this.id, required this.content_id,required this.content_type});

  @override
  List<Object?> get props => [id, content_id, content_type];
}

class AttachmentAddEvent extends AttachmentEvent {
  final int content_id;
  final String content_type;
  final File file;

  AttachmentAddEvent({
    required this.content_id,
    required this.content_type,
    required this.file,
  });

  @override
  List<Object?> get props => [content_type, content_id, file];
}