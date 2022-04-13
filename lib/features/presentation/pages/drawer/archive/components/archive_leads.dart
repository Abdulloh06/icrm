/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/features/presentation/pages/leads/components/lead_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class ArchiveLeads extends StatelessWidget {
  const ArchiveLeads({
    Key? key,
    required this.leads,
    required this.search,
  }) : super(key: key);

  final List<LeadsModel> leads;
  final String search;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(leads.isNotEmpty) {
          return ListView.builder(
            itemCount: leads.length,
            itemBuilder: (context, index) {
              return Visibility(
                visible: leads[index].contact != null ? leads[index].contact!.name.toLowerCase().contains(search.toLowerCase()) : true,
                child: GestureDetector(
                  child: LeadCard(
                    lead: leads[index],
                  ),
                ),
              );
            },
          );
        }else {
          return Center(
            child: LocaleText('empty'),
          );
        }
      },
    );
  }
}
