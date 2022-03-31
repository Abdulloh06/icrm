import 'package:avlo/core/service/api/auth/get_user.dart';
import 'package:avlo/core/service/api/auth/get_yandex_email.dart';
import 'package:avlo/core/service/api/auth/login_service.dart';
import 'package:avlo/core/service/api/auth/sign_up_service.dart';
import 'package:avlo/core/service/api/auth/social_auth.dart';
import 'package:avlo/core/service/api/get_attachment.dart';
import 'package:avlo/core/service/api/get_calendar.dart';
import 'package:avlo/core/service/api/get_contacts.dart';
import 'package:avlo/core/service/api/get_leads.dart';
import 'package:avlo/core/service/api/get_notes.dart';
import 'package:avlo/core/service/api/get_profile.dart';
import 'package:avlo/core/service/api/get_project_statuses.dart';
import 'package:avlo/core/service/api/get_projects.dart';
import 'package:avlo/core/service/api/get_task_status.dart';
import 'package:avlo/core/service/api/get_tasks.dart';
import 'package:avlo/core/service/api/get_team.dart';
import 'package:avlo/core/service/api/get_user_categories.dart';
import 'package:avlo/core/service/api/get_users.dart';
import 'package:avlo/core/service/api/leads_message.dart';
import 'package:get_it/get_it.dart';
import '../service/api/get_company.dart';
import '../service/api/get_dash_board.dart';
import '../service/api/get_leads_status.dart';
import '../service/api/get_portfolio.dart';

final getIt = GetIt.instance;

void setUpGetIt() {

  getIt.registerFactory<GetLeads>(() => GetLeads());
  getIt.registerFactory<GetContacts>(() => GetContacts());

  getIt.registerSingleton<SignUpService>(SignUpService());
  getIt.registerSingleton<GetProjects>(GetProjects());

  getIt.registerLazySingleton<LoginService>(() => LoginService());
  getIt.registerLazySingleton<GetUser>(() => GetUser());
  getIt.registerLazySingleton<YandexAuth>(() => YandexAuth());
  getIt.registerLazySingleton<GetCompany>(() => GetCompany());
  getIt.registerLazySingleton<GetUserCategories>(() => GetUserCategories());
  getIt.registerLazySingleton<GetDashBoard>(() => GetDashBoard());
  getIt.registerLazySingleton<GetProfile>(() => GetProfile());
  getIt.registerLazySingleton<GetNotes>(() => GetNotes());
  getIt.registerLazySingleton<GetLeadsStatus>(() => GetLeadsStatus());
  getIt.registerLazySingleton<GetProjectStatuses>(() => GetProjectStatuses());
  getIt.registerLazySingleton<GetTasks>(() => GetTasks());
  getIt.registerLazySingleton<GetPortfolio>(() => GetPortfolio());
  getIt.registerLazySingleton<GetTasksStatus>(() => GetTasksStatus());
  getIt.registerLazySingleton<GetAttachment>(() => GetAttachment());
  getIt.registerLazySingleton<GetTeam>(() => GetTeam());
  getIt.registerLazySingleton<GetCalendar>(() => GetCalendar());
  getIt.registerLazySingleton<SocialAuth>(() => SocialAuth());
  getIt.registerLazySingleton<GetUsers>(() => GetUsers());
  getIt.registerLazySingleton<LeadsMessage>(() => LeadsMessage());
}
