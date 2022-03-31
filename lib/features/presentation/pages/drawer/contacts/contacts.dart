import 'package:avlo/core/models/contacts_model.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_event.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_state.dart';
import 'package:avlo/features/presentation/pages/profile/pages/add_person.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_person_contact.dart';
import 'package:avlo/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avlo/widgets/main_tab_bar.dart';

class Contacts extends StatefulWidget {
  Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<ContactsBloc>().add(ContactsInitEvent());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 52),
          child: AppBarBack(
            title: 'contacts',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainTabBar(
                tabs: [
                  Tab(text: Locales.string(context, 'team')),
                  Tab(text: Locales.string(context, 'work')),
                  Tab(text: Locales.string(context, 'other')),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              MainSearchBar(
                controller: _searchController,
                onComplete: () {
                  FocusScope.of(context).unfocus();
                  context.read<ContactsBloc>().add(ContactsInitEvent());
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddParticipant())),
                child: Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        children: [
                          LocaleText(
                            'add',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset('assets/icons_svg/add_small.svg'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: BlocBuilder<ContactsBloc, ContactsState>(
                  builder: (context, state) {
                    if (state is ContactsInitState && state.contacts.isNotEmpty) {
                      List<ContactModel> team = state.contacts
                          .where((element) => element.contact_type == 1 && element.source == 2).toList();
                      List<ContactModel> work = state.contacts
                          .where((element) => element.contact_type == 2 && element.source == 2).toList();
                      List<ContactModel> other = state.contacts
                          .where((element) => element.contact_type == 10 && element.source == 2).toList();

                      return TabBarView(
                        children: [
                          BuildList(
                            list: team,
                            search: _searchController.text,
                          ),
                          BuildList(
                            list: work,
                            search: _searchController.text,
                          ),
                          BuildList(
                            list: other,
                            search: _searchController.text,
                          ),
                        ],
                      );
                    } else if(state is ContactsInitState && state.contacts.isEmpty) {
                      return Center(
                        child: LocaleText("empty"),
                      );
                    }
                    else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                child: MainPersonContact(
                  name: list[index].name,
                  photo: list[index].avatar,
                  response: list[index].position,
                  phone_number: list[index].phone_number,
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
