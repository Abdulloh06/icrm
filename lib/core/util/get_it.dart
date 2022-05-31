/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/service/api/auth/social/get_yandex_email.dart';
import 'package:icrm/core/service/api/auth/login_service.dart';
import 'package:icrm/core/service/api/auth/sign_up_service.dart';
import 'package:icrm/core/service/api/auth/social/social_auth.dart';
import 'package:icrm/core/service/api/get_attachment.dart';
import 'package:icrm/core/service/api/get_calendar.dart';
import 'package:icrm/core/service/api/get_contacts.dart';
import 'package:icrm/core/service/api/get_leads.dart';
import 'package:icrm/core/service/api/get_notes.dart';
import 'package:icrm/core/service/api/get_profile.dart';
import 'package:icrm/core/service/api/get_projects.dart';
import 'package:icrm/core/service/api/get_tasks.dart';
import 'package:icrm/core/service/api/get_team.dart';
import 'package:icrm/core/service/api/get_user_categories.dart';
import 'package:icrm/core/service/api/get_users.dart';
import 'package:icrm/core/service/api/leads_message.dart';
import 'package:get_it/get_it.dart';
import '../service/api/auth/social/get_google_email.dart';
import '../service/api/get_company.dart';
import '../service/api/get_dash_board.dart';
import '../service/api/get_status.dart';
import '../service/api/get_portfolio.dart';

final getIt = GetIt.instance;

void setUpGetIt() {

  getIt.registerFactory<GetLeads>(() => GetLeads());
  getIt.registerFactory<GetContacts>(() => GetContacts());

  getIt.registerSingleton<SignUpService>(SignUpService());
  getIt.registerSingleton<GetProjects>(GetProjects());

  getIt.registerLazySingleton<LoginService>(() => LoginService());
  getIt.registerLazySingleton<YandexAuth>(() => YandexAuth());
  getIt.registerLazySingleton<GetCompany>(() => GetCompany());
  getIt.registerLazySingleton<GetUserCategories>(() => GetUserCategories());
  getIt.registerLazySingleton<GetDashBoard>(() => GetDashBoard());
  getIt.registerLazySingleton<GetProfile>(() => GetProfile());
  getIt.registerLazySingleton<GetNotes>(() => GetNotes());
  getIt.registerLazySingleton<GetStatus>(() => GetStatus());
  getIt.registerLazySingleton<GetTasks>(() => GetTasks());
  getIt.registerLazySingleton<GetPortfolio>(() => GetPortfolio());
  getIt.registerLazySingleton<GetAttachment>(() => GetAttachment());
  getIt.registerLazySingleton<GetTeam>(() => GetTeam());
  getIt.registerLazySingleton<GetCalendar>(() => GetCalendar());
  getIt.registerLazySingleton<SocialAuth>(() => SocialAuth());
  getIt.registerLazySingleton<GetUsers>(() => GetUsers());
  getIt.registerLazySingleton<LeadsMessage>(() => LeadsMessage());
  getIt.registerLazySingleton<GetGoogleEmail>(() => GetGoogleEmail());
}
