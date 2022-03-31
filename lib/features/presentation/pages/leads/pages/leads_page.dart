import 'package:avlo/core/repository/api_repository.dart';
import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/core/util/colors.dart';
import 'package:avlo/core/util/text_styles.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_event.dart';
import 'package:avlo/features/presentation/blocs/lead_messages_bloc/lead_messages_bloc.dart';
import 'package:avlo/features/presentation/blocs/lead_messages_bloc/lead_messages_event.dart';
import 'package:avlo/features/presentation/blocs/lead_messages_bloc/lead_messages_state.dart';
import 'package:avlo/features/presentation/pages/add_project/local_pages/add_leads_page.dart';
import 'package:avlo/features/presentation/pages/project/pages/project_document_page.dart';
import 'package:avlo/features/presentation/pages/tasks/components/gridview_tasks.dart';
import 'package:avlo/features/presentation/pages/tasks/pages/create_task.dart';
import 'package:avlo/widgets/assign_members.dart';
import 'package:avlo/widgets/circular_progress_bar.dart';
import 'package:avlo/widgets/main_app_bar.dart';
import 'package:avlo/widgets/main_bottom_bar.dart';
import 'package:avlo/widgets/main_tab_bar.dart';
import 'package:avlo/widgets/projects.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import '../../../../../core/models/sms_model.dart';
import '../../../../../core/service/sms_service.dart';
import '../../../../../widgets/drawer.dart';
import '../../../blocs/home_bloc/home_state.dart';

class LeadsPage extends StatefulWidget {
  LeadsPage({
    Key? key,
    required this.id,
    required this.phone_number,
  }) : super(key: key);

  final int id;
  final String phone_number;

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _dynamicLink = FirebaseDynamicLinksPlatform.instance;
  final SMSService smsService = SMSService();
  late Future<List<SMSModel>> smsFuture;
  bool showLoading = false;

  Future<List<SMSModel>> getMessages() async {
    return await smsService.getMessages(phone: widget.phone_number);
  }

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LeadsShowEvent(id: widget.id));
    context.read<LeadMessageBloc>().add(LeadMessageInitEvent(id: widget.id));
    smsFuture = getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<HomeBloc>().add(HomeInitEvent());
        return true;
      },
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is LeadShowState) {
          String start_date = '';
          String deadline = '';

          try {
            start_date = DateFormat("dd.MM.yyyy")
                .format(DateTime.parse(state.lead.startDate));
            deadline = DateFormat("dd.MM.yyyy")
                .format(DateTime.parse(state.lead.endDate));
          } catch (error) {
            start_date = state.lead.startDate;
            deadline = state.lead.endDate;
          }

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              key: _scaffoldKey,
              endDrawer: const MainDrawer(),
              appBar: PreferredSize(
                preferredSize: Size(double.infinity, 52),
                child: MainAppBar(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(HomeInitEvent());
                  },
                  project: true,
                  title: state.lead.project!.name,
                  scaffoldKey: _scaffoldKey,
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color:
                          UserToken.isDark ? AppColors.mainDark : Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.only(
                        top: 23, right: 20, left: 20, bottom: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.lead.contact != null
                                  ? state.lead.contact!.phone_number
                                  : "",
                              style: AppTextStyles.headerLeads,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 3),
                                    height: 33,
                                    width: 33,
                                    child: Icon(
                                      Icons.share,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                  onTap: () async {
                                    await Share.share(ApiRepository.appUrl);
                                    // _dynamicLink
                                    //     .buildShortLink(DynamicLinkParameters(
                                    //   uriPrefix: ApiRepository.appUrl,
                                    //   link: Uri.parse(ApiRepository.appUrl),
                                    //   androidParameters:
                                    //       const AndroidParameters(
                                    //     packageName: 'uz.eurosoft.avlolead',
                                    //     minimumVersion: 1,
                                    //   ),
                                    //   iosParameters: const IOSParameters(
                                    //     bundleId: "uz.eurosoft.avlolead",
                                    //     minimumVersion: '2',
                                    //   ),
                                    // ))
                                    //     .then((value) {
                                    //   return Share.share(Uri.decodeFull(
                                    //       value.shortUrl.origin));
                                    // });
                                  },
                                ),
                                SizedBox(width: 5),
                                GestureDetector(
                                  child: SvgPicture.asset(
                                      'assets/icons_svg/edit.svg'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Material(
                                                  child: SafeArea(
                                                    child: Leads(
                                                      fromEdit: true,
                                                      lead: state.lead,
                                                    ),
                                                  ),
                                                )));
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Builder(
                              builder: (context) {
                                if (state.leadStatus.indexWhere((element) =>
                                        element.id ==
                                        state.lead.leadStatusId) ==
                                    0) {
                                  return CircularProgressBar(percent: 5);
                                } else if (state.lead.leadStatusId ==
                                    state.leadStatus.last.id) {
                                  return CircularProgressBar(percent: 100);
                                } else {
                                  return CircularProgressBar(
                                      percent: 95 /
                                          (state.leadStatus.length.toDouble() -
                                              1) *
                                          (state.leadStatus.indexWhere(
                                              (element) =>
                                                  element.id ==
                                                  state.lead.leadStatusId)));
                                }
                              },
                            ),
                            SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LocaleText(
                                  'team',
                                  style: AppTextStyles.mainTextFont.copyWith(
                                      color: UserToken.isDark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: state
                                                    .lead.member!.social_avatar,
                                                errorWidget: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                      'assets/png/no_user.png');
                                                },
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 30,
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) =>
                                                        AssignMembers(
                                                          id: 1,
                                                          lead: state.lead,
                                                        ));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.white),
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icons_svg/add_icon.svg',
                                                  height: 35,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons_svg/calendar_bg.svg',
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '${start_date} - ${deadline}',
                                        style: AppTextStyles.descriptionGrey,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        LocaleText(
                          'customer',
                          style: AppTextStyles.mainTextFont.copyWith(
                              color: UserToken.isDark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          children: [
                            Projects(
                              fontSize: 14,
                              borderWidth: 1,
                              title: state.lead.contact != null
                                  ? state.lead.contact!.name
                                  : "",
                            ),
                            SizedBox(width: 8),
                            Projects(
                              horizontalPadding: 7,
                              verticalPadding: 5,
                              widget: true,
                              borderWidth: 1,
                              title: SvgPicture.asset(
                                'assets/icons_svg/call.svg',
                                height: 15,
                                width: 11,
                                color: AppColors.greyDark,
                              ),
                            ),
                            SizedBox(width: 8),
                            Projects(
                              verticalPadding: 7,
                              horizontalPadding: 7,
                              widget: true,
                              borderWidth: 1,
                              title: SvgPicture.asset(
                                'assets/icons_svg/chat.svg',
                                height: 13,
                                width: 7,
                                color: AppColors.greyDark,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<HomeBloc>()
                                    .add(LeadsDeleteEvent(id: state.lead.id));
                                Navigator.pop(context);
                              },
                              child: Projects(
                                borderWidth: 1,
                                verticalPadding: 7,
                                horizontalPadding: 8,
                                widget: true,
                                title: SvgPicture.asset(
                                  'assets/icons_svg/delete.svg',
                                  height: 12,
                                  width: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 130,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColors.greenLight,
                                  ),
                                  child: Text(
                                    state.lead.project!.userCategory!.title,
                                    style: TextStyle(
                                      color: AppColors.green,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/icons_svg/add_icon.svg',
                                    height: 35,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            PopupMenuButton(
                              elevation: 0,
                              color: Colors.transparent,
                              itemBuilder: (context) {
                                return List.generate(state.leadStatus.length,
                                    (index) {
                                  return PopupMenuItem(
                                    padding: const EdgeInsets.only(),
                                    onTap: () {
                                      context.read<HomeBloc>().add(
                                            LeadsUpdateEvent(
                                              id: state.lead.id,
                                              project_id: state.lead.projectId,
                                              contact_id: state.lead.contactId,
                                              start_date: state.lead.startDate,
                                              end_date: state.lead.endDate,
                                              estimated_amount:
                                                  state.lead.estimatedAmount,
                                              lead_status:
                                                  state.leadStatus[index].id,
                                              description:
                                                  state.lead.description,
                                              seller_id: state.lead.seller_id,
                                              currency:
                                                  state.lead.currency ?? "USD",
                                              fromHome: false,
                                            ),
                                          );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                              vertical: 5)
                                          .copyWith(left: 20, right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Color(
                                          int.parse(state
                                              .leadStatus[index].color
                                              .split('#')
                                              .join('0xff')),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.leadStatus[index].name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 30),
                                          SvgPicture.asset(
                                            'assets/icons_svg/menu_icon.svg',
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5)
                                    .copyWith(left: 20, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(
                                    int.parse(state.lead.leadStatus!.color
                                        .split('#')
                                        .join('0xff')),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.lead.leadStatus!.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    SvgPicture.asset(
                                      'assets/icons_svg/menu_icon.svg',
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
                          child: MainTabBar(
                            tabs: [
                              Tab(
                                text: Locales.string(context, 'task_list'),
                              ),
                              Tab(
                                text: Locales.string(context, 'files'),
                              ),
                              Tab(
                                text: Locales.string(context, 'lead_chat'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20)
                                        .copyWith(top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateTask(
                                                    task_id: state.lead.id,
                                                    task_type: 'lead',
                                                  ),
                                                ));
                                          },
                                          child: Row(
                                            children: [
                                              LocaleText(
                                                'add',
                                                style: AppTextStyles.mainBold
                                                    .copyWith(
                                                  color: UserToken.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SvgPicture.asset(
                                                  'assets/icons_svg/add_yellow.svg'),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            LocaleText('filter',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff82868C),
                                                )),
                                            Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              size: 30,
                                              color: const Color(0xff82868C),
                                            ),
                                          ],
                                        ),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                    Expanded(
                                      child: GridViewTasks(
                                          tasks: state.lead.tasks!),
                                    ),
                                  ],
                                ),
                              ),
                              ProjectDocumentPage(
                                project_id: state.lead.projectId,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
                                child: BlocBuilder<LeadMessageBloc,
                                        LeadMessagesState>(
                                    builder: (context, leadMessage) {
                                  if (leadMessage is LeadMessagesInitState) {
                                    return Scaffold(
                                      body: ScrollConfiguration(
                                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                                        child: ListView.separated(
                                          itemCount:
                                              leadMessage.messages.length,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 10);
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              alignment: leadMessage.messages[index]
                                                          .user_id != state.lead.createdBy
                                                  ? Alignment.centerLeft
                                                  : Alignment.centerRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: UserToken.isDark
                                                    ? AppColors.cardColorDark
                                                    : Colors.white,
                                              ),
                                              child: Text(leadMessage.messages[index].message),
                                            );
                                          },
                                        ),
                                      ),
                                      bottomNavigationBar: Container(
                                        height: 70,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: UserToken.isDark
                                              ? AppColors.cardColorDark
                                              : Colors.white,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: UserToken.isDark
                                                ? AppColors.mainDark
                                                : Color.fromRGBO(
                                                    241, 244, 247, 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: TextField(
                                            cursorColor: AppColors.mainColor,
                                            controller: controller,
                                            decoration: InputDecoration(
                                              prefixIcon: CircleAvatar(
                                                backgroundColor: Color.fromRGBO(
                                                    220, 223, 227, 1),
                                                child: SvgPicture.asset(
                                                    'assets/icons_svg/clip.svg',
                                                    height: 14),
                                              ),
                                              border: InputBorder.none,
                                              hintText: Locales.string(
                                                  context, 'write_message'),
                                              suffixIcon: GestureDetector(
                                                onTap: () async {
                                                  await smsService.sendSMS(
                                                    phone: state.lead.contact!.phone_number,
                                                    message: controller.text,
                                                  );
                                                  context.read<LeadMessageBloc>().add(
                                                    LeadMessagesSendEvent(
                                                      lead_id: state.lead.id,
                                                      message: controller.text,
                                                      user_id: state.lead.createdBy,
                                                      client_id: state.lead.contact!.id,
                                                    ),
                                                  );
                                                  controller.clear();
                                                  setState(() {});
                                                },
                                                child: SvgPicture.asset(
                                                    'assets/icons_svg/send.svg'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.mainColor,
                                      ),
                                    );
                                  }
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: MainBottomBar(isMain: false),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            ),
          );
        }
      }),
    );
  }
}
