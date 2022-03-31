import 'package:avlo/core/models/profile_model.dart';

class UserModel {

  final int id;
  final ProfileModel user;

  UserModel({
    required this.id,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
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