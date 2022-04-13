/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

class LeadsStatusModel {
  final int id;
  final int user_id;
  final String name;
  final String color;
  final int is_system;
  final int sequence;
  final String created_at;
  final String updated_at;


  LeadsStatusModel({
    required this.id,
    required this.name,
    required this.user_id,
    required this.sequence,
    required this.is_system,
    required this.color,
    required this.created_at,
    required this.updated_at,
  });

  factory LeadsStatusModel.fromJson(Map<String, dynamic> json) {
    return LeadsStatusModel(
      id: json['id'],
      name: json['name'],
      is_system: json['is_system'],
      color: json['color'] ?? "0xff7703fc",
      user_id: json['user_id'] ?? '',
      sequence: json['sequence'] ?? '',
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }

  static List<LeadsStatusModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<LeadsStatusModel> statuses = [];

    for (int i = 0; i < items.length; i++) {
      statuses.add(LeadsStatusModel.fromJson(items[i]));
    }
    return statuses;
  }
}
