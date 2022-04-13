/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/profile_model.dart';

class UserModel {

  final int task_id;
  final int user_id;
  final ProfileModel user;

  UserModel({
    required this.task_id,
    required this.user,
    required this.user_id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'],
      task_id: json['task_id'],
      user: ProfileModel.fromJson(json['user']),
    );
  }

  static List<UserModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<UserModel> users = [];

    for(int i = 0; i < items.length; i++) {
      users.add(UserModel.fromJson(items[i]));
    }
    return users;
  }

}