/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/features/presentation/pages/drawer/notifications/notifications_card.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Notifications extends StatelessWidget {
  Notifications({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'notifications',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocaleText('categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            const SizedBox(height: 20),
            MainSearchBar(
              controller: _searchController,
              onComplete: () {},
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return NotificationCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
