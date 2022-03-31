class TaskStatusModel {
  final int id;
  final int user_id;
  final int sequence;
  final String name;
  final String color;
  final String created_at;
  final String updated_at;

  TaskStatusModel({
    required this.id,
    required this.user_id,
    required this.name,
    required this.sequence,
    required this.color,
    required this.created_at,
    required this.updated_at,
  });

  factory TaskStatusModel.fromJson(Map<String, dynamic> json) {
    return TaskStatusModel(
      id: json['id'],
      user_id: json['user_id'],
      name: json['name'],
      sequence: json['sequence'],
      color: json['color'] ?? "0xffa434eb",
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }

  static List<TaskStatusModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<TaskStatusModel> list = [];

    for(int i = 0; i < items.length; i++) {
      list.add(TaskStatusModel.fromJson(items[i]));
    }

    return list;
  }
}
