/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

class MessageModel {
  final int id;
  final int lead_id;
  final dynamic user_id;
  final dynamic client_id;
  final String message;
  final String created_at;
  final String updated_at;

  MessageModel({
    required this.id,
    required this.lead_id,
    required this.user_id,
    required this.client_id,
    required this.message,
    required this.created_at,
    required this.updated_at,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      lead_id: json['lead_id'],
      user_id: json['user_id'],
      client_id: json['client_id'],
      message: json['message'],
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
    );
  }

  static List<MessageModel> fetchData(Map<String, dynamic> data) {
    List items = data['data'];
    List<MessageModel> messages = [];

    for(int i = 0; i < items.length; i++) {
      messages.add(MessageModel.fromJson(items[i]));
    }

    return messages;
  }
}
