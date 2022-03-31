import 'package:avlo/features/presentation/pages/profile/components/notes_card.dart';
import 'package:flutter/material.dart';

class PhoneCalls extends StatelessWidget {
  const PhoneCalls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return PhoneCallsCard(
            people: [
              'Adam',
              'Jane'
            ],
            title: 'Mobile App Development',
            date: '12:00',
          );
        },
      ),
    );
  }
}
