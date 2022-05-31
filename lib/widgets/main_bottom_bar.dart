/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/features/presentation/blocs/cubits/bottom_bar_cubit.dart';
import 'package:icrm/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:icrm/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:icrm/features/presentation/pages/add_project/add_project.dart';
import 'package:icrm/features/presentation/pages/tasks/pages/create_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/presentation/blocs/home_bloc/home_bloc.dart';

class MainBottomBar extends StatelessWidget {
  const MainBottomBar({
    Key? key,
    this.isMain = true,
    this.fromTask = false,
    this.fromLead = false,
  }) : super(key: key);

  final bool isMain;
  final bool fromLead;
  final bool fromTask;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarCubit, int>(
      builder: (context, value) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: false,
            currentIndex: value,
            onTap: (index) {
              if(isMain) {
                if(index != 2) {
                  context.read<BottomBarCubit>().changePage(index);
                } else if(index == 2 && value == 3) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTask()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProject(page: value)));
                }
              }else {
                if(fromTask) {
                  context.read<TasksBloc>().add(TasksInitEvent());
                }
                if(fromLead) {
                  context.read<HomeBloc>().add(HomeInitEvent());
                }
                if(index != 2) {
                  Navigator.pop(context);
                  context.read<BottomBarCubit>().changePage(index);
                } else if(index == 2 && value == 3) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateTask()));
                } else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddProject(page: index)));
                }
              }
            },
            type: BottomNavigationBarType.fixed,
            items: [
              item('home'),
              item('projects'),
              item('add_icon'),
              item('tasks'),
              item('profile'),
            ],
          ),
        );
      },
    );
  }
}

BottomNavigationBarItem item(String icon) {
  return BottomNavigationBarItem(
    icon: SvgPicture.asset("assets/icons_svg/" + icon + ".svg"),
    activeIcon: SvgPicture.asset("assets/icons_svg/" + icon + "_active.svg"),
    label: '',
  );
}