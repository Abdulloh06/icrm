import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_event.dart';
import 'package:avlo/features/presentation/pages/add_project/local_pages/add_leads_page.dart';
import 'package:avlo/features/presentation/pages/add_project/local_pages/add_projects_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:avlo/core/util/colors.dart';


class AddProject extends StatefulWidget {

  const AddProject({Key? key, required this.page}) : super(key: key);

  final num page;

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> with TickerProviderStateMixin{
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);

    if(widget.page == 1) {
      controller.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          context.read<ProjectsBloc>().add(ProjectsInitEvent());
          return true;
        },
        child: Scaffold(
          backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
            appBar: AppBar(
              backgroundColor: UserToken.isDark ? AppColors.mainDark : Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Locales.string(context, "create")),
                  Expanded(
                    child: Container(
                      width: 193,
                      height: 38,
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        controller: controller,
                        isScrollable: false,
                        labelStyle: TextStyle(fontSize: 14),
                        unselectedLabelColor: AppColors.mainColor,
                        automaticIndicatorColorAdjustment: false,
                        indicator: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tabs: [
                          Tab(
                            text: Locales.string(context, 'led'),
                          ),
                          Tab(
                            text: Locales.string(context, 'project'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: TabBarView(
                controller: controller,
                children: [
                  Leads(),
                  Projects(),
                ],
              ),
            )),
      ),
    );
  }
}
