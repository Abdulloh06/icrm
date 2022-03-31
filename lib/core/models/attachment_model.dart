import 'dart:io';

class AttachmentModel {
  final int id;
  final String content_type;
  final dynamic content_id;
  final String file_name;
  final String path;
  final String file_type;
  final String created_at;
  final String updated_at;

  AttachmentModel({
    required this.id,
    required this.path,
    required this.created_at,
    required this.updated_at,
    required this.content_id,
    required this.file_name,
    required this.content_type,
    required this.file_type,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'],
      path: json['path'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      content_id: json['content_type'],
      file_name: json['file_name'],
      content_type: json['content_type'],
      file_type: json['file_type'],
    );
  }

  static List<AttachmentModel> showContent(Map<String, dynamic> data) {
    List items = data['data'];
    List<AttachmentModel> docs = [];

    for(int i = 0; i < items.length; i++) {
      docs.add(AttachmentModel.fromJson(items[i]));
    }

    return docs;
  }

}
