/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:flutter/foundation.dart';

@immutable
class ContactModel {
  final int id;
  final String name;
  final String position;
  final String phone_number;
  final String email;
  final dynamic created_by;
  final dynamic contact_type;
  final String avatar;
  final int source;
  final dynamic telegramId;

  ContactModel({
    required this.id,
    required this.name,
    required this.position,
    required this.phone_number,
    required this.email,
    required this.created_by,
    required this.contact_type,
    required this.avatar,
    required this.source,
    required this.telegramId,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(id: json['id'],
      name: json['name'] ?? "",
      position: json['position'] ?? "",
      phone_number: json['phone_number'] ?? "",
      email: json['email'] ?? "",
      created_by: json['created_by'],
      contact_type: json['contact_type'],
      avatar: json['avatar'] ?? "",
      source: json['source'],
      telegramId: json['telegram_chat_id'],
    );
  }


  static List<ContactModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<ContactModel> contacts = [];

    for(int i = 0; i < items.length; i++) {
      contacts.add(ContactModel.fromJson(items[i]));
    }

    return contacts;
  }

}