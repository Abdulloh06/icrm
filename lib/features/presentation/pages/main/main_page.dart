import 'main_page_includes.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final List<Widget> _list;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void getData() {
    context.read<HomeBloc>().add(HomeInitEvent());
    context.read<ProjectsBloc>().add(ProjectsInitEvent());
    context.read<TasksBloc>().add(TasksInitEvent());
    context.read<UserCategoriesBloc>().add(UserCategoriesInitEvent());
    context.read<ContactsBloc>().add(ContactsInitEvent());
    context.read<ProjectStatusBloc>().add(ProjectStatusesInitEvent());
    context.read<PortfolioBloc>().add(PortfolioInitEvent());
  }

  @override
  void initState() {

    super.initState();
    _list = [
      HomePage(scaffoldKey: scaffoldKey),
      CreateProject(scaffoldKey: scaffoldKey),
      const Scaffold(),
      NewTasks(scaffoldKey: scaffoldKey),
      Profile(scaffoldKey: scaffoldKey),
    ];

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarCubit, int>(
      builder: (context, state) {
        return Scaffold(
          endDrawer: const MainDrawer(),
          key: scaffoldKey,
          body: _list[state],
          bottomNavigationBar: const MainBottomBar(),
        );
      },
    );
  }
}
