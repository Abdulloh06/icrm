/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'package:icrm/core/service/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_page_includes.dart';

class MainPage extends StatefulWidget {
  MainPage({
    Key? key,
    this.isMain = true,
  }) : super(key: key);

  final bool isMain;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final List<Widget> _list;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void getData() async {
    if(widget.isMain) {
      context.read<ProfileBloc>().add(ProfileInitEvent());
    }
    context.read<HomeBloc>().add(HomeInitEvent());
    context.read<ProjectsBloc>().add(ProjectsInitEvent());
    context.read<TasksBloc>().add(TasksInitEvent());
    context.read<ProjectStatusBloc>().add(ProjectStatusesInitEvent());
    context.read<PortfolioBloc>().add(PortfolioInitEvent());
    Future.delayed(Duration(seconds: 4), () {
      context.read<SwipeAnimationCubit>().disableAnimation();
    });

  }

  @override
  void initState() {
    super.initState();

    _list = [
      HomePage(scaffoldKey: scaffoldKey),
      CreateProject(scaffoldKey: scaffoldKey),
      const Scaffold(),
      NewTasks(scaffoldKey: scaffoldKey),
      Profile(scaffoldKey: scaffoldKey),
    ];
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if(state is ProfileErrorState && state.error.toLowerCase().contains("invalid refresh token")) {
          SharedPreferencesService.instance.then((value) => value.setAuth(false));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AuthMainPage()),
                (route) => false,
          );
        }
      },
      child: BlocBuilder<BottomBarCubit, int>(
        builder: (context, state) {
          return Scaffold(
            endDrawer: const MainDrawer(),
            key: scaffoldKey,
            body: _list[state],
            bottomNavigationBar: const MainBottomBar(),
          );
        },
      ),
    );
  }
}
