/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:dio/dio.dart';
import '../../../repository/api_repository.dart';
import '../../../repository/user_token.dart';
import '../../shared_preferences_service.dart';

class SignUpService {

  final dio = Dio();

  Future<String> signUpStepOne({required String email, required String phone}) async {
    try {
      final response = await dio.post(
        ApiRepository.registerStepOne,
        data: email == '' ? {"phone_number": phone} : {"email": email},
      ).timeout(const Duration(seconds: 60), onTimeout: () {
        throw Exception("TIME OUT");
      });

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return '';
      } else if (data['errors'] != null) {
        return 'user';
      } else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        return response.statusMessage.toString();
      }

    } catch (error) {
      print(error);
      if(error.toString().contains('302')) {
        return 'user_already_exist';
      }else {
        return 'something_went_wrong';
      }
    }
  }

  Future<bool> registerStepTwo({required String via, required int code}) async {
    try {

      final response = await dio.post(
        ApiRepository.registerStepTwo,
        data: {
          "via": via,
          "code": code,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
        ),
      );

      if(response.statusCode == HttpStatus.ok) {
        final data = response.data;

        if(data['data']['confirmed'] == true) {
          return true;
        }else {
          return false;
        }
      } else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        print(response.statusMessage);
        throw Exception(response.statusMessage);
      }

    } catch (error) {
      print(error);
      return false;
    }

  }

  Future<bool> registerConfirmation({required String via, required String password, required String confirmPassword}) async{

    try {
      final response = await dio.post(
        ApiRepository.registerConfirmation,
        data: {
          "via": via,
          "password": password,
          "password_confirmation": confirmPassword
        },
      );

      final Map<String, dynamic> data = await response.data;


      if(response.statusCode == HttpStatus.created || response.statusCode == HttpStatus.ok) {
        SharedPreferencesService.instance.then((prefs) {
          prefs.setUserInfo(data: data, fromSignUp: true);
          prefs.setTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'],
          );

          UserToken.phoneNumber = prefs.getPhoneNumber;
          UserToken.email = prefs.getEmail;
          UserToken.accessToken = prefs.getAccessToken;
          UserToken.refreshToken = prefs.getRefreshToken;
        });

        return true;
      } else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        print(response.statusMessage.toString() + "ERROR WHILE REGISTER CONFIRMATION");
        throw Exception(response.statusMessage);
      }

    } catch (error) {
      print(error);
      throw Exception('UNKNOWN ERROR');
    }
  }

}