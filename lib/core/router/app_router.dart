import 'package:avlo/core/repository/user_token.dart';
import 'package:avlo/features/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:avlo/features/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:avlo/features/presentation/blocs/calendar_bloc/calendar_bloc.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:avlo/features/presentation/blocs/contacts_bloc/contacts_state.dart';
import 'package:avlo/features/presentation/blocs/cubits/auth_page_slider_cubit.dart';
import 'package:avlo/features/presentation/blocs/cubits/bottom_bar_cubit.dart';
import 'package:avlo/features/presentation/blocs/cubits/theme_cubit.dart';
import 'package:avlo/features/presentation/blocs/helper_bloc/helper_state.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:avlo/features/presentation/blocs/home_bloc/home_state.dart';
import 'package:avlo/features/presentation/blocs/lead_messages_bloc/lead_messages_bloc.dart';
import 'package:avlo/features/presentation/blocs/notes_bloc/notes_bloc.dart';
import 'package:avlo/features/presentation/blocs/notes_bloc/notes_state.dart';
import 'package:avlo/features/presentation/blocs/portfolio_bloc/portfolio_state.dart';
import 'package:avlo/features/presentation/blocs/profile_bloc/profile_state.dart';
import 'package:avlo/features/presentation/blocs/project_statuses_bloc/project_statuses_bloc.dart';
import 'package:avlo/features/presentation/blocs/project_statuses_bloc/project_statuses_state.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_bloc.dart';
import 'package:avlo/features/presentation/blocs/projects_bloc/projects_state.dart';
import 'package:avlo/features/presentation/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:avlo/features/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:avlo/features/presentation/blocs/team_bloc/team_state.dart';
import 'package:avlo/features/presentation/blocs/user_categories_bloc/user_categories_bloc.dart';
import 'package:avlo/features/presentation/blocs/user_categories_bloc/user_categories_state.dart';
import 'package:avlo/features/presentation/blocs/users_bloc/users_bloc.dart';
import 'package:avlo/features/presentation/blocs/users_bloc/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/presentation/blocs/attachment_bloc/attachment_bloc.dart';
import '../../features/presentation/blocs/attachment_bloc/attachment_state.dart';
import '../../features/presentation/blocs/calendar_bloc/calendar_state.dart';
import '../../features/presentation/blocs/company_bloc/company_bloc.dart';
import '../../features/presentation/blocs/helper_bloc/helper_bloc.dart';
import '../../features/presentation/blocs/lead_messages_bloc/lead_messages_state.dart';
import '../../features/presentation/blocs/portfolio_bloc/portfolio_bloc.dart';
import '../../features/presentation/blocs/profile_bloc/profile_bloc.dart';

class AppRouter {
  List blocs() {
    return [
      BlocProvider(
        create: (_) => BottomBarCubit(),
      ),
      BlocProvider(
        create: (_) => AuthPageSliderCubit(),
      ),
      BlocProvider(
        create: (_) => AuthBloc(AuthInitState()),
      ),
      BlocProvider(create: (_) => ThemeCubit(UserToken.isDark)),
      BlocProvider(
        create: (_) => NotesBloc(NotesLoadingState()),
      ),
      BlocProvider(
        create: (_) => ContactsBloc(ContactsLoadingState()),
      ),
      BlocProvider(create: (_) => CompanyBloc(CompanyLoadingState())),
      BlocProvider(
        create: (_) => UserCategoriesBloc(UserCategoriesLoadingState()),
      ),
      BlocProvider(create: (_) => ProjectsBloc(ProjectsLoadingState())),
      BlocProvider(
        create: (_) => ProfileBloc(ProfileLoadingState()),
      ),
      BlocProvider(create: (_) => TasksBloc(TasksLoadingState())),
      BlocProvider(
        create: (_) => ProjectStatusBloc(ProjectStatusLoadingState()),
      ),
      BlocProvider(create: (_) => PortfolioBloc(PortfolioLoadingState())),
      BlocProvider(create: (_) => AttachmentBloc(AttachmentLoadingState())),
      BlocProvider(create: (_) => HomeBloc(HomeLoadingState()),),
      BlocProvider(create: (_) => TeamBloc(TeamLoadingState())),
      BlocProvider(create: (_) => HelperBloc(HelperLoadingState())),
      BlocProvider(create: (_) => CalendarBloc(CalendarLoadingState()),),
      BlocProvider(create: (_) => UsersBloc(UsersLoadingState())),
      BlocProvider(create: (_) => LeadMessageBloc(LeadMessagesLoadingState())),
    ];
  }
}
