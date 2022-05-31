/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

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
    bool toRefresh = false,
  }) async {

    Map<String, dynamic> formData;
    if(toRefresh) {
      formData = {
        "refresh_token": UserToken.refreshToken,
      };
    } else {
      formData = {
        "username": username,
        "password": password,
        "reg_id": UserToken.fmToken,
      };
    }
    try {
      print(UserToken.fmToken);
      final response = await dio.post(
        ApiRepository.login,
        data: formData,
      );

      final Map<String, dynamic> data = await response.data;

      if (response.statusCode == HttpStatus.ok) {

        SharedPreferencesService.instance.then((prefs) {
          prefs.setTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'],
            expiresIn: data['expires_in'],
          );

          UserToken.authStatus = prefs.getAuth;
          UserToken.accessToken = prefs.getAccessToken;
          UserToken.refreshToken = prefs.getRefreshToken;
        });

        return '';
      }else {
        throw Exception('UNKNOWN');
      }

    } on DioError catch(e) {
      final Map<String, dynamic> data = e.response!.data;

      if(data['error'] == 'invalid_grant') {
        return 'user_not_found';
      } else if(data['error_description'].toString().toLowerCase().contains('refresh token')) {
        return "refresh_token";
      } else {
        throw Exception('UNKNOWN');
      }
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {

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
          "password": oldPassword,
          "new_confirmation": newPassword,
          "new_password_confirmation": newPassword,
        },
      );

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else {
        throw Exception('UNKNOWN');
      }

    } on DioError catch(e) {
      final Map<String, dynamic> data = await e.response!.data;
      print(data['errors']);
      throw Exception('UNKNOWN');
    }

  }

}