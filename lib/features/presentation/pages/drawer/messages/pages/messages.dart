import 'package:avlo/features/presentation/pages/drawer/messages/components/chat_card.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_search_bar.dart';
import 'package:avlo/widgets/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:telephony/telephony.dart';

class Messages extends StatelessWidget {
  Messages({Key? key}) : super(key: key);

  final _searchController = TextEditingController();

  final _telephony = Telephony.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 52),
          child: AppBarBack(
            title: 'messages',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: Column(
              children: [
                MainTabBar(
                  tabs: [
                    Tab(text: Locales.string(context, 'all')),
                    Tab(text: Locales.string(context, 'recently'),),
                    Tab(text: Locales.string(context, 'not_read')),
                  ],
                ),
                const SizedBox(height: 20),
                MainSearchBar(
                  controller: _searchController,
                  onComplete: () {},
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              List<SmsMessage> messages = await _telephony.getInboxSms();
                              List<SmsConversation> conversations = await _telephony.getConversations();
                              print(messages);
                              print(conversations[0].snippet);
                            },
                            child: ChatsCard(
                              name: 'Джейн Купер',
                              image: 'assets/png/img.png',
                              lastMessages: 'Lorem ipsum dolor sit amet, onsectetur adipiscing elit. ',
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await _telephony.sendSms(
                                to: '998996037105',
                                message: 'I AM WRITING FROM CRM',
                                statusListener: (status) {
                                  if(status == SendStatus.SENT) {
                                    print('SENT');
                                  }
                                  if(status == SendStatus.DELIVERED) {
                                    print('DELIVERED');
                                  }
                                }
                              );
                            },
                            child: ChatsCard(
                              name: 'Джейн Купер',
                              image: 'assets/png/img.png',
                              lastMessages: 'Lorem ipsum dolor sit amet, onsectetur adipiscing elit. ',
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return ChatsCard(
                            name: 'Джейн Купер',
                            image: 'assets/png/img_1.png',
                            lastMessages: 'Lorem ipsum dolor sit amet, onsectetur adipiscing elit. ',
                          );
                        },
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}