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

  Future<String> signUpStepOne({
    required String email,
    required String phone,
  }) async {
    print(phone);
    Map<String, dynamic> formData = {};

    if(email.isEmpty) {
      formData.addAll({
        "phone_number": phone,
      });
    }else {
      formData.addAll({
        "email": email,
      });
    }
    try {
      final response = await dio.post(
        ApiRepository.registerStepOne,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.contentTypeHeader: "application/json",
          }
        ),
        data: formData,
      ).timeout(const Duration(seconds: 60), onTimeout: () {
        throw Exception("TIME OUT");
      });

      if(response.statusCode == HttpStatus.ok) {
        return '';
      } else {
        return 'something_went_wrong';
      }

    } on DioError catch (e) {
      final data = e.response!.data;
      print(data);
      if(data['errors'] != null) {
        return 'user_already_exists';
      } else {
        throw Exception('UNKNOWN');
      }
    }
  }

  Future<String> registerStepTwo({
    required String via,
    required int code,
  }) async {
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
        return "";
      } else {
        print(response.statusMessage);
        throw Exception("UNKNOWN");
      }

    } on DioError catch (e) {
      final Map<String, dynamic> data = await e.response!.data;

      if(data['message'].toString().toLowerCase() == "wrong code!") {
        return "wrong_code";
      }else if(data['message'].toString().toLowerCase() == "sms was expired!"){
        return "code_expired";
      } else {
        throw Exception('UNKNOWN');
      }
    }

  }

  Future<bool> registerConfirmation({
    required String via,
    required String password,
  }) async{

    try {
      final response = await dio.post(
        ApiRepository.registerConfirmation,
        data: {
          "via": via,
          "password": password,
          "password_confirmation": password,
          "reg_id": UserToken.fmToken,
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