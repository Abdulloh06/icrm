/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'package:icrm/core/util/main_includes.dart';
import 'package:icrm/core/util/text_styles.dart';
import 'package:icrm/features/presentation/pages/add_succes_pages/add_lead_page.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

void backgroundMessageHandler(SmsMessage message) async {

}

void main() async {

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

  runApp(AvloApp());
}


class AvloApp extends StatelessWidget {

  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
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
                theme: state ? dark : light,
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
  final _dynamicLinks = FirebaseDynamicLinks.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initDynamicLinks() async {
    _dynamicLinks.onLink.listen((event) {
      String link = event.link.toString();
      print(link);
      if(UserToken.authStatus) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddLeadsPage(id: int.parse(link.split('/').last), phone_number: '')));
      }
    });
  }
  Future<void> setLanguage() async {
    final _prefs = await SharedPreferences.getInstance();

    String languageCode = await _prefs.getString(PrefsKeys.languageCode) ?? 'ru';

    context.changeLocale(languageCode);
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    setLanguage();
    _firebaseMessaging.getToken().then((value) {
      UserToken.fmToken = value.toString();
      FirebaseMessaging.onMessage.listen((message) {

      });
    });
    print(UserToken.id);
  }

  @override
  Widget build(BuildContext context) {
    return UserToken.authStatus ? MainPage() : AuthMainPage();
  }
}

