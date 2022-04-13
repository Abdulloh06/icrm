/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/features/presentation/pages/drawer/companies/components/company_card.dart';
import 'package:icrm/features/presentation/pages/drawer/companies/pages/sub_company.dart';
import 'package:icrm/widgets/main_app_bar.dart';
import 'package:icrm/widgets/main_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubCompany(),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is CompanyInitState && state.companies.isEmpty) {
                      return Center(
                        child: Text(
                          'No Company',
                          style: AppTextStyles.mainGrey,
                        ),
                      );
                    } else {
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
