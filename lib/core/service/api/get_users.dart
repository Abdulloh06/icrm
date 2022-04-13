/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class GetUsers {

  final dio = Dio();

  Future<List<TeamModel>> getUsers({required String search}) async {

    try {

      final response = await dio.get(
        ApiRepository.getUser + "?search=$search",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          }
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return TeamModel.fetchData(data);
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    }catch(error, stackTrace) {
      print(error);
      print(stackTrace);

      throw Exception('UNKNOWN');
    }

  }

  Future<bool> sendInivitation({
    required String via,
    required String model_type,
    required int model_id,
  }) async {

    try {

      final response = await dio.post(
        ApiRepository.inviteUser,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),
        data: {
          "via": via,
          "model_type": "task",
          "model_id": model_id,
        }
      );

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError){
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(error) {
      print(error);

      throw Exception('UNKNOWN');
    }

  }

}