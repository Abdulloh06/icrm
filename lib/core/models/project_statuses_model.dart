class ProjectStatusesModel {
  final int id;
  final int user_id;
  final int sequence;
  final String name;
  final String created_at;
  final String updated_at;
  final String color;

  ProjectStatusesModel({
    required this.id,
    required this.name,
    required this.user_id,
    required this.updated_at,
    required this.created_at,
    required this.sequence,
    required this.color,
  });

  factory ProjectStatusesModel.fromJson(Map<String, dynamic> json) {
    return ProjectStatusesModel(
      id: json['id'],
      name: json['name'],
      user_id: json['user_id'],
      updated_at: json['updated_at'] ?? "",
      created_at: json['created_at'] ?? "",
      sequence: json['sequence'],
      color: json['color'] ?? "0xff",
    );
  }

  static List<ProjectStatusesModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<ProjectStatusesModel> projectStatuses = [];

    for(int i = 0; i < items.length; i++) {
      projectStatuses.add(ProjectStatusesModel.fromJson(items[i]));
    }

    return projectStatuses;
  }
}
