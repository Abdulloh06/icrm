
class UserCategoriesModel {
  final int id;
  final int user_id;
  final String title;
  final String created_at;
  final String updated_at;

  UserCategoriesModel({
    required this.user_id,
    required this.id,
    required this.title,
    required this.created_at,
    required this.updated_at,
  });

  factory UserCategoriesModel.fromJson(Map<String, dynamic> json) {
    return UserCategoriesModel(
      user_id: json['user_id'],
      id: json['id'],
      title: json['name'],
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }

  static List<UserCategoriesModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<UserCategoriesModel> list = [];

    for(int i = 0; i < items.length; i++) {
      list.add(UserCategoriesModel.fromJson(items[i]));
    }

    return list;
  }
}