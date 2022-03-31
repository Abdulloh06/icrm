import 'package:avlo/core/util/colors.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_lead_card.dart';
import 'package:avlo/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

class SubCompany extends StatelessWidget {
  SubCompany({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'companies',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainSearchBar(
              controller: _searchController,
              onComplete: () {},
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 113,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      children: [
                        LocaleText('add', style: const TextStyle(color: Colors.white, fontSize: 15),),
                        const SizedBox(width: 7),
                        SvgPicture.asset('assets/icons_svg/add_small.svg'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return MainLeadCard(
                      title: 'Разработка UI/UX ',
                      last: 'Внес изменения в структ . . .',
                      date: '10.09.2021 ',
                      client1: 'IT-Park',
                      price: 9594.00,
                      client2: 'Сардор',
                      priority: 'Завершено',
                      priorityColor: AppColors.greenLight,
                      leadColor: AppColors.green,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
