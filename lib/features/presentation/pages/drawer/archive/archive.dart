import 'package:avlo/core/util/colors.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_lead_card.dart';
import 'package:avlo/widgets/main_search_bar.dart';
import 'package:avlo/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class Archive extends StatelessWidget {
  Archive({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 52),
          child: AppBarBack(title: 'archive',),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MainTabBar(
                tabs: [
                  Tab(text: Locales.string(context, 'leads')),
                  Tab(text: Locales.string(context, 'tasks')),
                  Tab(text: Locales.string(context, 'targets')),
                ],
              ),
              const SizedBox(height: 20,),
              MainSearchBar(
                controller: _searchController,
                onComplete: () {},
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return MainLeadCard(
                            title: 'Разработка UI/UX ',
                            last: 'Внес изменения в структ . . .',
                            date: '10.09.2021 ',
                            client1: 'IT-Park',
                            price: 03494.0,
                            client2: 'Сардор',
                            priority: 'Завершено',
                            leadColor: AppColors.green,
                            priorityColor: AppColors.greenLight,
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return MainLeadCard(
                            title: 'Разработка UI/UX ',
                            last: 'Внес изменения в структ . . .',
                            date: '10.09.2021 ',
                            client1: 'IT-Park',
                            price: 09843.00,
                            client2: 'Сардор',
                            priority: 'Завершено',
                            priorityColor: AppColors.greenLight,
                            leadColor: AppColors.green,
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return MainLeadCard(
                            title: 'Разработка UI/UX ',
                            last: 'Внес изменения в структ . . .',
                            date: '10.09.2021 ',
                            client1: 'IT-Park',
                            price: 0303.00,
                            client2: 'Сардор',
                            priority: 'Завершено',
                            priorityColor: AppColors.redLight,
                            leadColor: AppColors.red,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
