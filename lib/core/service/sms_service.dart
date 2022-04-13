/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:telephony/telephony.dart';
import '../models/sms_model.dart';

class SMSService {

  static final Telephony _telephony = Telephony.instance;

  Future<void> initListening() async {}

  Future<void> messageHandler() async {
    _telephony.listenIncomingSms(
      onNewMessage: (message) {
        print("message");
      }
    );
  }

  Future<void> sendSMS({
    required String phone,
    required String message,
  }) async {
    if (await _telephony.requestSmsPermissions ?? true) {
      try {
        await _telephony.sendSms(
          to: phone,
          message: message,
        );
      }catch(error) {
        print(error);
      }
    } else {
      print("NO Permission");
    }
  }

  Future<List<SMSModel>> getMessages({required String phone}) async {
    try {
      var inbox = await _telephony.getInboxSms(
          filter: SmsFilter.where(SmsColumn.ADDRESS).equals(phone),
          sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)]
      );

      var sent = await _telephony.getSentSms(
        filter: SmsFilter.where(SmsColumn.ADDRESS).equals(phone),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.ASC)],
      );
      var messages = <SMSModel>[];

      for (int i = 0; i < inbox.length; i++) {
        messages.add(SMSModel(
          date: inbox[i].date ?? 0,
          message: inbox[i].body ?? '',
          isMyMessage: false,
        ));
      }

      for (int i = 0; i < sent.length; i++) {
        messages.add(SMSModel(
          date: sent[i].date ?? 0,
          message: sent[i].body ?? '',
          isMyMessage: true,
        ));
      }

      messages.sort((a, b) => a.date.compareTo(b.date));

      return messages;
    }catch(e) {
      print(e);
      return [];
    }
  }
}
