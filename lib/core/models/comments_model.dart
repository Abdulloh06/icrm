/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:flutter/foundation.dart';

@immutable
class CommentsModel {
  final int id;
  final dynamic parent_id;
  final String content;
  final String comment_type;
  final int created_by;
  final String commentable_type;
  final dynamic commentable_id;
  final String created_at;
  final String updated_at;

  CommentsModel({
    required this.parent_id,
    required this.content,
    required this.comment_type,
    required this.created_by,
    required this.commentable_id,
    required this.commentable_type,
    required this.created_at,
    required this.updated_at,
    required this.id,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      id: json['id'],
      parent_id: json['parent_id'],
      content: json['content'],
      comment_type: json['comment_type'],
      created_by: json['created_by'],
      commentable_id: json['commentable_id'],
      commentable_type: json['commentable_type'],
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }

  static List<CommentsModel> fetchData(List data) {
    List items = data;
    List<CommentsModel> comments = [];

    for(int i = 0; i < items.length; i++) {
      comments.add(CommentsModel.fromJson(items[i]));
    }

    return comments;
  }
}
