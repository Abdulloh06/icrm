/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:flutter/foundation.dart';

@immutable
class NotesModel {
  final int id;
  final String title;
  final String content;
  final String created_at;
  final String updated_at;
  final int created_by;

  NotesModel({
    required this.title,
    required this.id,
    required this.content,
    required this.created_at,
    required this.created_by,
    required this.updated_at,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json){
    return NotesModel(
      title: json['title'],
      content: json['content'],
      created_at: json['created_at'] as String,
      id: json['id'],
      created_by: json['created_by'],
      updated_at: json['updated_at'] as String,
    );
  }

  static List<NotesModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<NotesModel> notes = [];

    for(int i = 0; i < items.length; i++) {
      notes.add(NotesModel.fromJson(items[i]));
    }

    return notes;
  }

}