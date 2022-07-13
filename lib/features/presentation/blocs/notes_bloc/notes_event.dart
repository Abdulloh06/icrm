/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:equatable/equatable.dart';

class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotesInitEvent extends NotesEvent {}

class NotesAddEvent extends NotesEvent {
  final String title;
  final String content;
  final List<String> images;

  NotesAddEvent({
    required this.title,
    required this.content,
    required this.images,
  });

  @override
  List<Object?> get props => [title, content, images];
}

class NotesDeleteEvent extends NotesEvent {
  final int id;

  NotesDeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class NotesUpdateEvent extends NotesEvent {
  final String title;
  final String content;
  final int id;

  NotesUpdateEvent({required this.content, required this.title, required this.id});

  @override
  List<Object?> get props => [content, title];
}

