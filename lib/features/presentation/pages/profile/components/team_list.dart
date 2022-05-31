/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../../core/models/team_model.dart';
import '../../../../../widgets/main_person_contact.dart';

class TeamList extends StatelessWidget {
  const TeamList({
    Key? key,
    required this.team,
    required this.search,
    required this.id,
  }) : super(key: key);

  final List<TeamModel> team;
  final String search;
  final int id;

  @override
  Widget build(BuildContext context) {
    List<TeamModel> list = [];
    switch(id) {
      case 1:
        list = team;
        break;
      case 2:
        list =  team
            .where((element) => element.is_often == 1)
            .toList();
        break;
      case 3:
        list =  team
            .where((element) => element.is_often == 0)
            .toList();
        break;
    }
    return Builder(
      builder: (context) {
        if(list.isNotEmpty) {
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              String name = list[index].first_name + list[index].last_name;

              return Visibility(
                visible: list[index].phoneNumber.contains(search)
                    || list[index].email.toLowerCase().contains(search.toLowerCase())
                    || name.toLowerCase().contains(search.toLowerCase()),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  margin:
                  const EdgeInsets.only(bottom: 10),
                  child: MainPersonContact(
                    name: list[index].first_name +
                        " " +
                        list[index].last_name,
                    response:
                    list[index].jobTitle,
                    photo: list[index].social_avatar,
                    phone_number: list[index].phoneNumber,
                    email: list[index].email,
                  ),
                ),
              );
            },
          );
        }else {
          return Center(
            child: LocaleText("empty"),
          );
        }
      },
    );
  }
}
