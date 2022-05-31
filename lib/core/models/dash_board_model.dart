/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:flutter/foundation.dart';

@immutable
class DashBoardModel {
  final String name;
  final int number;
  final int lead_status_id;
  final String color;

  DashBoardModel({
    required this.name,
    required this.number,
    required this.lead_status_id,
    required this.color,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    return DashBoardModel(
      name: json['name'] ?? "",
      number: json['number'] ?? 0,
      lead_status_id: json["label_id"],
      color: json['color'] ?? "#6146C6"
    );
  }

  static List<DashBoardModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<DashBoardModel> list = [];

    for(int i = 0; i < items.length; i++) {
      list.add(DashBoardModel.fromJson(items[i]));
    }
    return list;
  }
}