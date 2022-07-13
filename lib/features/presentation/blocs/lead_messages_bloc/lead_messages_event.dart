/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:equatable/equatable.dart';

import '../../../../core/models/message_model.dart';

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

class GetMessageFromNotification extends LeadMessagesEvent {
  final int id;
  final String message;
  final int clientId;
  final int leadId;
  final List<MessageModel> messages;

  GetMessageFromNotification({
    required this.id,
    required this.message,
    required this.clientId,
    required this.leadId,
    required this.messages,
  });

  @override
  List<Object?> get props => [id, leadId, clientId, messages, message];
}