import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/models/status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../../core/util/text_styles.dart';
import '../../leads/components/lead_card.dart';
import '../../leads/pages/leads_page.dart';

class SearchLeads extends StatelessWidget {
  const SearchLeads({
    Key? key,
    required this.search,
    required this.leadStatuses,
    required this.leads,
  }) : super(key: key);

  final String search;
  final List<LeadsModel> leads;
  final List<StatusModel> leadStatuses;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (leads.isNotEmpty) {
          return ListView.builder(
              itemCount: leads.length,
              itemBuilder: (context, index) {
                return Visibility(
                  visible: leads[index].contact!.name.toLowerCase().contains(search.toLowerCase()),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeadsPage(
                            lead: leads[index],
                            leadStatuses: leadStatuses,
                          ),
                        ),
                      );
                    },
                    child: LeadCard(
                      lead: leads[index],
                    ),
                  ),
                );
              });
        } else {
          return Center(
            child: LocaleText(
              'empty',
              style: AppTextStyles.mainGrey,
            ),
          );
        }
      },
    );
  }
}
