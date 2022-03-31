import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/features/presentation/blocs/cubits/bottom_bar_cubit.dart';
import 'package:avlo/features/presentation/pages/drawer/contacts/contacts.dart';
import 'package:avlo/features/presentation/pages/profile/components/profile_category.dart';
import 'package:avlo/features/presentation/pages/profile/pages/event_calendar.dart';
import 'package:avlo/features/presentation/pages/profile/pages/notes/my_notes.dart';
import 'package:avlo/features/presentation/pages/profile/pages/portfolio.dart';
import 'package:avlo/features/presentation/pages/profile/pages/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileMainCategories extends StatelessWidget {
  const ProfileMainCategories({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.35,
      child: GridView.count(
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: [
          ProfileCategory(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Portfolio())),
            title: "my_portfolio",
            icon: UserToken.isDark ? "assets/icons_svg/portfolio_dark.svg" : "assets/icons_svg/portfolio.svg",
          ),
          ProfileCategory(
            onTap: () => context.read<BottomBarCubit>().changePage(3),
            title: "my_tasks",
            icon: UserToken.isDark ? "assets/icons_svg/tasks_dark.svg" : "assets/icons_svg/profile_tasks.svg",
          ),
          ProfileCategory(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyTeam())),
            title: "my_team",
            icon: UserToken.isDark ? "assets/icons_svg/team_dark.svg" : "assets/icons_svg/team.svg",
          ),
          ProfileCategory(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventCalendar())),
            title: "calendar_events",
            icon: UserToken.isDark ? "assets/icons_svg/calendar_dark.svg" : "assets/icons_svg/calendar.svg",
          ),
          ProfileCategory(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyNotes())),
            title: "my_notes",
            icon: UserToken.isDark ? "assets/icons_svg/profile_notes_dark.svg" : "assets/icons_svg/profile_notes.svg",
          ),
          ProfileCategory(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Contacts())),
            title: "my_contacts",
            icon: UserToken.isDark ? "assets/icons_svg/profile_contacts_dark.svg" : "assets/icons_svg/profile_contacts.svg",
          ),
        ],
      ),
    );
  }
}
