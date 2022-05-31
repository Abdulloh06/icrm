/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:dio/dio.dart';
import '../../../../repository/user_token.dart';
import '../../../shared_preferences_service.dart';

class SocialAuth {
  final dio = Dio();

  Future<String> socialAuth({
    required String name,
    required String password,
    required String auth_type,
    required String phone_number,
    required String email,
    String surname = '',
  }) async {

    try {

      Map<String, dynamic> formData = {
        "client_id": "95c1af20-7626-4a65-be25-c83d07e7be5b",
        "client_secret": "E5lebmGUQwxCpjnG9mqa5RJI7FIdTknoNZYh4ibx",
        "oauth_id": password,
        "oauth_type": auth_type,
        "email": email,
        "username": name,
        "name": name,
        "password": password,
        "reg_id": UserToken.fmToken,
      };

      if(phone_number != '') {
        formData.addAll({
          "phone_number": phone_number,
        });
      }

      final response = await dio.post(
        ApiRepository.social_auth,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-type": "application/json",
          }
        ),
        data: formData,
      );

      final  Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {

        SharedPreferencesService.instance.then((prefs) {
          prefs.setTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'] != null ? data['refresh_token'] : "",
            expiresIn: data['expires_in'],
          );

          UserToken.authStatus = true;
          UserToken.accessToken = prefs.getAccessToken;
          UserToken.refreshToken = prefs.getRefreshToken;
        });

        return '';
      } else {
        return 'something_went_wrong';
      }

    } on DioError catch(e) {
      final Map<String, dynamic> data = e.response!.data;
      print(data);

      if(data['errors']['email'] != null) {
        return 'email';
      } else if(e.response!.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }
    }

  }

}