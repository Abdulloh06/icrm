import 'package:meta/meta.dart';

@immutable
class SMSModel {

  final int date;
  final String message;
  final bool isMyMessage;

  const SMSModel({
    required this.date,
    required this.message,
    required this.isMyMessage,
  });
}