/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/service/firebase_service.dart';
import 'package:icrm/core/util/main_includes.dart';
import 'package:icrm/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'core/util/colors.dart';

void main() async {
  final _notification = NotificationService();
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: true,
    ),
    body: Center(
      child: LocaleText("something_went_wrong", style: AppTextStyles.mainGrey,),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Locales.init(['ru', 'en']);
  await _notification.initialize();

  setUpGetIt();
  SharedPreferencesService.instance.then((pref) {
    UserToken.isDark = pref.getTheme;
    UserToken.id = pref.getUserId;
    UserToken.languageCode = pref.getLanguageCode;
    UserToken.authStatus = pref.getAuth;
    UserToken.name = pref.getName;
    UserToken.email = pref.getEmail;
    UserToken.surname = pref.getSurname;
    UserToken.phoneNumber = pref.getPhoneNumber;
    UserToken.username = pref.getUsername;
    UserToken.userPhoto = pref.getUserPhoto;
    UserToken.accessToken = pref.getAccessToken;
    UserToken.refreshToken = pref.getRefreshToken;
    UserToken.responsibility = pref.getResponsibility;
  });

  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiBlocProvider(
      providers: [..._router.blocs()],
      child: LocaleBuilder(
        builder: (locale) {
          return BlocBuilder<ThemeCubit, bool>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: Locales.delegates,
                locale: locale,
                supportedLocales: Locales.supportedLocales,
                title: 'Avlo Lead',
                theme: state ? AppThemes.dark : AppThemes.light,
                home: AvloLead(),
              );
            },
          );
        },
      ),
    );
  }
}

class AvloLead extends StatefulWidget {
  const AvloLead({Key? key}) : super(key: key);

  @override
  _AvloLeadState createState() => _AvloLeadState();
}

class _AvloLeadState extends State<AvloLead> {
  final _firebaseService = FirebaseService();

  int exitTime = 0;
  void _setLanguage() async {
    final _prefs = await SharedPreferences.getInstance();
    String languageCode = await _prefs.getString(PrefsKeys.languageCode) ?? 'en';

    context.changeLocale(languageCode);
  }

  @override
  void initState() {
    super.initState();
    _setLanguage();
    _firebaseService.initMessaging();
    if(UserToken.authStatus) {
      _firebaseService.initDynamicLinks(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Loading().build(context);
    return WillPopScope(
      onWillPop: () async {
        Future.delayed(Duration(seconds: 5), () {
          exitTime = 0;
        });
        if(exitTime == 0) {
          exitTime++;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(20),
              backgroundColor: AppColors.mainColor,
              content: LocaleText("are_you_sure_to_exit", style: AppTextStyles.mainGrey.copyWith(color: Colors.white)),
            ),
          );
          return false;
        }else {
          return true;
        }
      },
      child: UserToken.authStatus ? MainPage() : AuthMainPage(),
    );
  }
}

