import 'dart:io';
import 'package:avlo/core/repository/user_token.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repository/api_repository.dart';
import '../../shared_preferences_service.dart';

class GetUser {

  final dio = Dio();

  Future getUser() async{
    try {

      final response = await dio.get(
        ApiRepository.getUser,
        options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer + ${UserToken.accessToken}",
            }
        ),
      );

      if(response.statusCode == HttpStatus.ok) {
        final data = response.data;

        SharedPreferencesService.instance.then((value) => value.setUserInfo(data: data, fromSignUp: false));
      }

    } catch (error) {
      print(error);

      throw Exception('ERROR');
    }
  }

  Future quitProfile() async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
    await _prefs.setBool(PrefsKeys.themeKey, UserToken.isDark);
  }

}