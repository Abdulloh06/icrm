/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';

import 'package:icrm/core/models/profile_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/service/shared_preferences_service.dart';
import 'package:dio/dio.dart';

import '../../repository/user_token.dart';

class GetProfile {

  final dio = Dio();

  Future<ProfileModel> getProfile() async{
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

      }else if(response.statusCode == HttpStatus.internalServerError){
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      throw Exception('UNKNOWN');
    }
  }
  
  
  Future<bool> changeProfile({
    required String name,
    required String surname,
    required String job_title,
    required String phoneNumber,
    required String email,
    required String username,
  }) async {
    
    try {
      
      final response = await dio.put(
        ApiRepository.getProfile,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
            "Content-Type": "application/json",
          },
        ),
        data: {
          "first_name": name,
          "last_name": surname,
          "phone_number": phoneNumber,
          "email": email,
          "username": username,
          "job_title": job_title,
        }
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

        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        return false;
      }
    } catch (error) {
      print(error);
      throw Exception('UNKNOWN');
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