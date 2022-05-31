
/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:flutter/foundation.dart';

@immutable
class ProfileModel {
  final int id;
  final String first_name;
  final String last_name;
  final String username;
  final String phone_number;
  final String email;
  final bool isVerified;
  final String job_title;
  final dynamic oauth_id;
  final dynamic oauth_type;
  final String social_avatar;
  final String created_at;
  final String updated_at;
  final bool is_often;

  const ProfileModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.job_title,
    required this.username,
    required this.email,
    required this.phone_number,
    required this.isVerified,
    required this.social_avatar,
    required this.updated_at,
    required this.created_at,
    required this.oauth_id,
    required this.oauth_type,
    required this.is_often,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      first_name: json['first_name'] ?? "",
      last_name: json['last_name'] ?? "",
      username: json['username'] ?? "",
      phone_number: json['phone_number'] ?? "",
      email: json['email'] ?? "",
      job_title: json['job_title'] ?? "",
      isVerified: json['is_verified'],
      social_avatar: json['social_avatar'] ?? "",
      oauth_id: json['oauth_id'] ?? "",
      oauth_type: json['oauth_type'] ?? "",
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
      is_often: json['is_often'] ?? true,
    );
  }

}