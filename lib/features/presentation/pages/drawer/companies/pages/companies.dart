/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/features/presentation/pages/drawer/companies/components/company_card.dart';
import 'package:icrm/features/presentation/pages/drawer/companies/pages/add_company.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/util/colors.dart';
import '../../../../../../core/util/text_styles.dart';
import '../../../../blocs/company_bloc/company_bloc.dart';

class Companies extends StatefulWidget {
  Companies({Key? key}) : super(key: key);

  @override
  State<Companies> createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    context.read<CompanyBloc>().add(CompanyInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 52),
        child: AppBarBack(
          title: 'companies',
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainSearchBar(
                controller: _searchController,
                onComplete: () {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCompany()),
                ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<CompanyBloc, CompanyState>(
                  builder: (context, state) {
                    if (state is CompanyInitState && state.companies.isNotEmpty) {
                      return ListView.builder(
                        itemCount: state.companies.length,
                        itemBuilder: (context, index) {
                          return Visibility(
                            visible: state.companies[index].name.toLowerCase().contains(_searchController.text.toLowerCase()),
                            child: CompanyCard(
                              image: state.companies[index].logo,
                              name: state.companies[index].name,
                              direction: state.companies[index].description,
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return AddCompany(
                                    fromEdit: true,
                                    company: state.companies[index],
                                  );
                                }));
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is CompanyInitState && state.companies.isEmpty) {
                      return Center(
                        child: LocaleText(
                          "empty",
                          style: AppTextStyles.mainGrey,
                        ),
                      );
                    } else {
                      return Loading();
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
