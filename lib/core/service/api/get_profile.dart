/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';

import 'package:icrm/core/models/profile_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/service/api/auth/login_service.dart';
import 'package:icrm/core/service/shared_preferences_service.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/user_token.dart';

class GetProfile {

  final dio = Dio();

  Future<ProfileModel> getProfile() async {
    try {

      final response = await dio.get(
        ApiRepository.getProfile,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
          },
        ),
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        await SharedPreferencesService.instance.then((pref) async {
          await pref.setUserInfo(data: data, fromSignUp: false);
          UserToken.id = pref.getUserId;
          UserToken.name = pref.getName;
          UserToken.email = pref.getEmail;
          UserToken.surname = pref.getSurname;
          UserToken.phoneNumber = pref.getPhoneNumber;
          UserToken.username = pref.getUsername;
          UserToken.userPhoto = pref.getUserPhoto;
          UserToken.responsibility = pref.getResponsibility;
        });


        return ProfileModel.fromJson(data['data']);

      } else {
        throw Exception('UNKNOWN PROFILE');
      }

    } on DioError catch (e) {
      if(e.response!.statusCode == HttpStatus.unauthorized) {
        try {
          String result = await getIt.get<LoginService>().login(
            username: '',
            password: '',
            toRefresh: true,
          );
          print(result + "-Refresh Token");

          if(result != "refresh_token") {
            return await getProfile();
          }else {
            final _prefs = await SharedPreferences.getInstance();
            await _prefs.clear();
            await _prefs.setBool(PrefsKeys.themeKey, UserToken.isDark);
            UserToken.clearAllData();
            UserToken.authStatus = false;
            throw Exception("INVALID REFRESH TOKEN");
          }
        } catch (_) {
          throw Exception("INVALID REFRESH TOKEN");
        }
      }else {
        throw Exception('UNKNOWN PROFILE');
      }
    }
  }

  Future<String> changeProfile({
    required String name,
    required String surname,
    required String job_title,
    required String phoneNumber,
    required String email,
    required String username,
  }) async {
    
    try {

      Map<String, dynamic> formData = {
        "first_name": name,
        "last_name": surname,
      };
      if(phoneNumber.isNotEmpty) {
        formData.addAll({
          "phone_number": phoneNumber,
        });
      }
      if(username.isNotEmpty) {
        formData.addAll({
          "username": username,
        });
      }
      if(email.isNotEmpty) {
        formData.addAll({
          "email": email,
        });
      }
      if(job_title.isNotEmpty) {
        formData.addAll({
          "job_title": job_title,
        });
      }

      final response = await dio.put(
        ApiRepository.getProfile,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
            "Content-Type": "application/json",
          },
        ),
        data: formData,
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {

        await SharedPreferencesService.instance.then((pref) async {
          await pref.setUserInfo(data: data, fromSignUp: false);
          UserToken.name = pref.getName;
          UserToken.email = pref.getEmail;
          UserToken.surname = pref.getSurname;
          UserToken.phoneNumber = pref.getPhoneNumber;
          UserToken.username = pref.getUsername;
          UserToken.userPhoto = pref.getUserPhoto;
          UserToken.responsibility = pref.getResponsibility;
        });

        return "";
      } else {
        throw Exception('UNKNOWN');
      }
    } on DioError catch (e) {
      final Map<String, dynamic> data = e.response!.data;

      print(data);
      if(data['errors'] != null) {
        if(data['errors']['username'] != null) {
          return "username_already_in_use";
        }else if(data['errors']['email'] != null) {
          return "email_already_in_use";
        }else if(data['errors']['phone_number'] != null) {
          return "phone_already_in_use";
        }else {
          return "something_went_wrong";
        }
      }else {
        throw Exception('UNKNOWN');
      }
    }
  }

  Future<bool> changeAvatar({
    required File image,
  }) async {

    try {

      String fileName = image.path.split('/').last;
      FormData formData = await FormData.fromMap({});

      formData.files.add(MapEntry('file', await MultipartFile.fromFile(image.path, filename: fileName)));

      final response = await dio.post(
        ApiRepository.baseUrl + "avatar",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          }
        ),
        data: formData,
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {

        await SharedPreferencesService.instance.then((pref) async {
          await pref.setUserInfo(data: data, fromSignUp: false);
          UserToken.name = pref.getName;
          UserToken.email = pref.getEmail;
          UserToken.surname = pref.getSurname;
          UserToken.phoneNumber = pref.getPhoneNumber;
          UserToken.username = pref.getUsername;
          UserToken.userPhoto = pref.getUserPhoto;
          UserToken.responsibility = pref.getResponsibility;
        });

        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    }catch (error) {
      print(error);
      throw Exception('UNKNOWN');
    }
  }

}