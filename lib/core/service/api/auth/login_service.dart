import 'dart:io';
import 'package:dio/dio.dart';
import '../../../repository/api_repository.dart';
import '../../../repository/user_token.dart';
import '../../shared_preferences_service.dart';

class LoginService {

  final dio = Dio();

  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiRepository.login,
        data: {
          "username": username,
          "password": password,
        },
      );

      final Map<String, dynamic> data = await response.data;

      if (response.statusCode == HttpStatus.ok) {

        SharedPreferencesService.instance.then((prefs) {
          prefs.setTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'],
          );

          UserToken.authStatus = prefs.getAuth;
          UserToken.accessToken = prefs.getAccessToken;
          UserToken.refreshToken = prefs.getRefreshToken;
        });

        return '';
      } else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        if(data['errors'] != null) {
          return 'user_not_found';
        }else {
          return 'something_went_wrong';
        }
      }
    } catch (e) {
      print(e);
      throw Exception('UNKNOWN');
    }
  }

  Future<bool> changePassword({required String password}) async {

    try {

      final response = await dio.put(
        ApiRepository.changePassword,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),
        data: {
          "password": password,
          "password_confirmation": password,
        },
      );

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(error) {
      print(error);

      throw Exception('UNKNOWN');
    }

  }
}