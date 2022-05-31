/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:flutter/foundation.dart';

@immutable
class StatusModel {
  final int id;
  final String name;
  final String color;
  final UserLabel? userLabel;


  const StatusModel({
    required this.id,
    required this.name,
    required this.color,
    required this.userLabel,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {

    UserLabel? label;
    if(json['userLabel'] != null) {
      label = UserLabel.fromJson(json['userLabel']);
    }

    return StatusModel(
      id: json['id'],
      name: json['name'],
      color: json['color'] ?? "0xff7703fc",
      userLabel: label,
    );
  }

  static List<StatusModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<StatusModel> statuses = [];

    for (int i = 0; i < items.length; i++) {
      statuses.add(StatusModel.fromJson(items[i]));
    }
    return statuses;
  }
}

@immutable
class UserLabel {
  final int id;
  final String name;
  final String color;
  final String created_at;
  final String updated_at;

  const UserLabel({
    required this.id,
    required this.name,
    required this.created_at,
    required this.color,
    required this.updated_at,
  });

  factory UserLabel.fromJson(Map<String, dynamic> json) {
    return UserLabel(
      id: json['id'],
      name: json['name'],
      color: json['color'] ?? "",
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }
}
