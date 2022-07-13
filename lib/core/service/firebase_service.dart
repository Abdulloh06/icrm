import 'dart:developer';

import 'package:icrm/core/service/locale_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import '../../features/presentation/pages/add_succes_pages/add_lead_page.dart';
import '../repository/user_token.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _notificationService = NotificationService();
  final _dynamicLinks = FirebaseDynamicLinks.instance;

  static Future<void> _myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      log('Hello: $data');
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      log('Hello notif: $notification');
    }
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    try {
      await _dynamicLinks.onLink.listen((event) async {
        String link = await event.link.toString();
        print(link);
        await Future.delayed(Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLeadsPage(
                id: int.parse(link.split('/').last),
                phone_number: '',
              ),
            ),
          );
        });
      });
    } catch(e) {
      print(e);
    }
  }

  void initMessaging() {
    _firebaseMessaging.getToken().then((value) {
      UserToken.fmToken = value.toString();
      FirebaseMessaging.onMessage.listen((message) async {
        if(message.notification != null) {
          try {
            _notificationService.showNotification(message);
            return;
          } catch(_) {}
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print(event.category);
        return print(event.data);
      });
      FirebaseMessaging.onBackgroundMessage((message) {
        return _myBackgroundMessageHandler(message.data);
      });
    });
  }
}