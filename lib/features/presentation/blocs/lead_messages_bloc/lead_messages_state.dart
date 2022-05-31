/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/message_model.dart';
import 'package:equatable/equatable.dart';

abstract class LeadMessagesState extends Equatable {}

class LeadMessagesInitState extends LeadMessagesState {

  final List<MessageModel> messages;

  LeadMessagesInitState({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class LeadMessagesLoadingState extends LeadMessagesState {
  @override
  List<Object?> get props => [];
}

class LeadMessagesErrorState extends LeadMessagesState {
  final String error;

  LeadMessagesErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}