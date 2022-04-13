/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

class DashBoardModel {
  final String name;
  final int number;
  final int lead_status_id;

  DashBoardModel({
    required this.name,
    required this.number,
    required this.lead_status_id,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    return DashBoardModel(
      name: json['name'] ?? "",
      number: json['number'] ?? 0,
      lead_status_id: json['lead_status_id'] ?? 0,
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