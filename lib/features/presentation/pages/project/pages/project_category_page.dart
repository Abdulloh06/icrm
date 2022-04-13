import 'package:icrm/core/models/user_categories_model.dart';
import 'package:icrm/core/service/api/get_user_categories.dart';
import 'package:icrm/core/util/colors.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:flutter/material.dart';

class ProjectCategoryPage extends StatefulWidget {
  const ProjectCategoryPage({
    Key? key,
    required this.projectCategory,
  }) : super(key: key);

  final int projectCategory;

  @override
  State<ProjectCategoryPage> createState() => _ProjectCategoryPageState();
}

class _ProjectCategoryPageState extends State<ProjectCategoryPage> {
  UserCategoriesModel? category;
  bool isLoading = true;

  Future getCategory() async {
    category = await getIt.get<GetUserCategories>().showUserCategory(id: widget.projectCategory);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategory().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    if(!isLoading) {
      return Container(
        margin: const EdgeInsets.all(20),
        color: AppColors.mainColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(category!.title),
      );
    }else {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.mainColor,
        ),
      );
    }
  }
}
