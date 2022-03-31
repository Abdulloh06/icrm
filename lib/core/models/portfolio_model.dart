import 'package:avlo/core/models/project_statuses_model.dart';
import 'package:avlo/core/models/user_categories_model.dart';

class PortfolioModel {
  final int id;
  final int userId;
  final int projectStatusId;
  final int userCategoryId;
  final String name;
  final String description;
  final String notifyAt;
  final double price;
  final String currency;
  final String createdAt;
  final String updatedAt;
  final UserCategoriesModel userCategory;
  final ProjectStatusesModel projectStatus;
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
    return PortfolioModel(
      id: json['id'],
      userId: json['user_id'],
      projectStatusId: json['project_status_id'],
      userCategoryId: json['user_category_id'],
      name: json['name'],
      description: json['description'],
      notifyAt: json['notify_at'],
      price: json['price'],
      currency: json['currency'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      userCategory: UserCategoriesModel.fromJson(json['userCategory']),
      projectStatus: ProjectStatusesModel.fromJson(json['projectStatus']),
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
