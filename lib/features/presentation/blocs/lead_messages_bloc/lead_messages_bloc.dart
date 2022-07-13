/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/models/message_model.dart';
import 'package:icrm/core/service/api/leads_message.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/lead_messages_bloc/lead_messages_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'lead_messages_state.dart';

class LeadMessageBloc extends Bloc<LeadMessagesEvent, LeadMessagesState> {
  LeadMessageBloc(LeadMessagesState initialState) : super(initialState) {
    on<LeadMessageInitEvent>((event, emit) => _init(event: event, emit: emit));
    on<LeadMessagesSendEvent>((event, emit) => _sendMessage(event: event, emit: emit));
    on<LeadMessagesDeleteEvent>((event, emit) => _deleteMessage(event: event, emit: emit));
    on<GetMessageFromNotification>((event, emit) => _getMessageFromNotification(event: event, emit: emit));
  }

  Future<void> _init({
    required LeadMessageInitEvent event,
    required Emitter<LeadMessagesState> emit,
  }) async {
    try {
      List<MessageModel> messages =
      await getIt.get<LeadsMessage>().getMessages(lead_id: event.id);

      emit(LeadMessagesInitState(messages: messages));
    } catch (error) {
      print(error);

      emit(LeadMessagesErrorState(error: error.toString()));
    }
  }

  Future<void> _sendMessage({
    required LeadMessagesSendEvent event,
    required Emitter<LeadMessagesState> emit,
  }) async {
    try {
      bool result = await getIt.get<LeadsMessage>().sendMessage(
        message: event.message,
        user_id: event.user_id,
        lead_id: event.lead_id,
        client_id: event.client_id,
      );

      if(result) {
        List<MessageModel> messages = await getIt.get<LeadsMessage>().getMessages(lead_id: event.lead_id);

        emit(LeadMessagesInitState(messages: messages));
      }else {
        emit(LeadMessagesErrorState(error: 'something_went_wrong'));
      }
    } catch (error) {
      print(error);

      emit(LeadMessagesErrorState(error: error.toString()));
    }
  }

  Future<void> _deleteMessage({
    required LeadMessagesDeleteEvent event,
    required Emitter<LeadMessagesState> emit,
  }) async {
    try {

      bool result = await getIt.get<LeadsMessage>().deleteMessage(id: event.id);

      if(result){
        List<MessageModel> messages = await getIt.get<LeadsMessage>().getMessages(lead_id: event.id);

        emit(LeadMessagesInitState(messages: messages));

      }else {
        emit(LeadMessagesErrorState(error: 'something_went_wrong'));
      }

    } catch(error) {
      print(error);

      emit(LeadMessagesErrorState(error: error.toString()));
    }
  }

  Future<void> _getMessageFromNotification({
    required GetMessageFromNotification event,
    required Emitter<LeadMessagesState> emit,
  }) async {

    try {

      List<MessageModel> messages = event.messages.reversed.toList();

      messages.add(MessageModel(
        id: event.id,
        lead_id: event.leadId,
        client_id: event.clientId,
        message: event.message,
        user_id: null,
        created_at: DateTime.now().toString(),
        updated_at: "",
      ));

      messages = messages.toList();

      emit(LeadMessagesInitState(messages: messages));

    } catch(e) {
      emit(LeadMessagesErrorState(error: "something_went_wrong"));
    }
  }


}
