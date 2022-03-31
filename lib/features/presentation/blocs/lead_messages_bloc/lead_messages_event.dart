import 'package:equatable/equatable.dart';

abstract class LeadMessagesEvent extends Equatable {}

class LeadMessageInitEvent extends LeadMessagesEvent {

  final int id;

  LeadMessageInitEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class LeadMessagesSendEvent extends LeadMessagesEvent {

  final String message;
  final int lead_id;
  final dynamic user_id;
  final dynamic client_id;

  LeadMessagesSendEvent({
    required this.lead_id,
    required this.message,
    required this.user_id,
    required this.client_id,
  });

  @override
  List<Object?> get props => [lead_id, message, user_id, client_id];
}

class LeadMessagesDeleteEvent extends LeadMessagesEvent {

  final int id;

  LeadMessagesDeleteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}