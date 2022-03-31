import 'package:avlo/features/presentation/blocs/cubits/bottom_bar_cubit.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:avlo/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:avlo/features/presentation/pages/add_project/add_project.dart';
import 'package:avlo/features/presentation/pages/tasks/pages/create_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/presentation/blocs/home_bloc/home_bloc.dart';

class MainBottomBar extends StatelessWidget {
  const MainBottomBar({
    Key? key,
    this.index = 1,
    this.isMain = true,
  }) : super(key: key);

  final bool isMain;
  final int index;

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
                if(index != 2) {
                  Navigator.pop(context);
                  context.read<BottomBarCubit>().changePage(index);
                  context.read<HomeBloc>().add(HomeInitEvent());
                  context.read<TasksBloc>().add(TasksInitEvent());
                } else if(index == 2 && value == 3) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateTask()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProject(page: index)));
                }
              }
            },
            type: BottomNavigationBarType.fixed,
            items: [
              item('assets/icons_svg/home.svg', 'assets/icons_svg/home_active.svg'),
              item('assets/icons_svg/projects.svg', 'assets/icons_svg/projects_active.svg'),
              item('assets/icons_svg/add_icon.svg', ''),
              item('assets/icons_svg/tasks.svg', 'assets/icons_svg/tasks_active.svg'),
              item('assets/icons_svg/profile.svg', 'assets/icons_svg/profile_active.svg'),
            ],
          ),
        );
      },
    );
  }
}

BottomNavigationBarItem item(String icon, activeIcon) {
  return BottomNavigationBarItem(
    icon: SvgPicture.asset(icon),
    activeIcon: SvgPicture.asset(activeIcon),
    label: '',
  );
}