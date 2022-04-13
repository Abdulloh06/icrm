import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/service/shared_preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit(bool initialState) : super(UserToken.isDark);

  void changeTheme(bool value) async {

    SharedPreferencesService.instance.then((pref) => pref.setTheme(value));

    emit(UserToken.isDark = value);

  }

}