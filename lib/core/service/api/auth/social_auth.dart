import 'dart:io';
import 'package:avlo/core/repository/api_repository.dart';
import 'package:dio/dio.dart';
import '../../../repository/user_token.dart';
import '../../shared_preferences_service.dart';

class SocialAuth {
  final dio = Dio();

  Future<String> socialAuth({
    required String name,
    required String password,
    required String auth_type,
    required String phone_number,
    required String email,
  }) async {

    try {

      final response = await dio.post(
        ApiRepository.social_auth,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-type": "application/json",
          }
        ),
        data: {
          "client_id": "95c1af20-7626-4a65-be25-c83d07e7be5b",
          "client_secret": "E5lebmGUQwxCpjnG9mqa5RJI7FIdTknoNZYh4ibx",
          "oauth_id": password,
          "oauth_type": auth_type,
          "email": email,
          "phone_number": phone_number,
          "username": name,
          "name": name,
          "password": password,
        }
      );

      final  Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {

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
      }else if(response.statusCode == HttpStatus.internalServerError){
        return 'SERVER ERROR';
      }else {
        throw Exception(response.statusMessage);
      }

    } catch(error) {
      print(error);
      throw Exception('UNKNOWN $error');
    }

  }

}