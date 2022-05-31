import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/models/contacts_model.dart';
import '../../../../../widgets/main_person_contact.dart';
import '../../../blocs/contacts_bloc/contacts_bloc.dart';
import '../../../blocs/contacts_bloc/contacts_event.dart';
import '../../profile/pages/add_person.dart';


class BuildList extends StatelessWidget {
  const BuildList({
    Key? key,
    required this.list,
    required this.search,
  }) : super(key: key);

  final List<ContactModel> list;
  final String search;

  @override
  Widget build(BuildContext context) {
    if (list.isNotEmpty) {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: list[index].name.toLowerCase().contains(search.toLowerCase()),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Dismissible(
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/icons_svg/delete.svg',
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons_svg/delete.svg',
                        height: 20,
                      ),
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  context.read<ContactsBloc>()
                      .add(ContactsDeleteEvent(id: list[index].id.toString()));
                },
                key: Key(list[index].id.toString()),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddParticipant(
                      fromEdit: true,
                      contact: list[index],
                    )));
                  },
                  child: MainPersonContact(
                    name: list[index].name,
                    photo: list[index].avatar,
                    response: list[index].position,
                    email: list[index].email,
                    phone_number: list[index].phone_number,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: LocaleText(
          "empty",
        ),
      );
    }
  }
}