/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/models/user_categories_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class PortfolioModel {
  final int id;
  final dynamic userId;
  final dynamic projectStatusId;
  final dynamic userCategoryId;
  final String name;
  final String description;
  final String notifyAt;
  final dynamic price;
  final String currency;
  final String createdAt;
  final String updatedAt;
  final UserCategoriesModel? userCategory;
  final StatusModel? projectStatus;
  final bool isOwner;

  PortfolioModel({
    required this.id,
    required this.userId,
    required this.projectStatusId,
    required this.userCategoryId,
    required this.name,
    required this.description,
    required this.notifyAt,
    required this.price,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    required this.userCategory,
    required this.projectStatus,
    required this.isOwner,
  });


  factory PortfolioModel.fromJson(Map<String, dynamic> json) {

    UserCategoriesModel? userCategory;
    if(json['userCategory'] != null) {
      userCategory = UserCategoriesModel.fromJson(json['userCategory']);
    }

    return PortfolioModel(
      id: json['id'],
      userId: json['user_id'],
      projectStatusId: json['project_status_id'],
      userCategoryId: json['user_category_id'],
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      notifyAt: json['notify_at'] ?? "",
      price: json['price'],
      currency: json['currency'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      userCategory: userCategory,
      projectStatus: StatusModel.fromJson(json['label']),
      isOwner: json['is_owner'],
    );
  }

  static List<PortfolioModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<PortfolioModel> list = [];

    for(int i = 0; i < items.length; i++) {
      list.add(PortfolioModel.fromJson(items[i]));
    }

    return list;
  }
}
