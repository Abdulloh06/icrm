/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/team_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:icrm/core/util/main_includes.dart';
import 'package:dio/dio.dart';

class GetTeam {

  final dio = Dio();

  Future<List<TeamModel>> getTeam() async {

    try {

      final response = await dio.get(
        ApiRepository.baseUrl + "employees",
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
        throw Exception(response.statusMessage);
      }

    } catch (error) {
      print(error);
      throw Exception('UNKNOWN TEAM' + error.toString());
    }

  }

  Future<bool> addTeamMember({required int id}) async {

    try {

      final response = await dio.post(
        ApiRepository.baseUrl + "employees",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type" : "application/json",
          },
        ),
        data: {
          "user_id": id,
          "is_often": false
        }
      );

      if(response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    }catch(error, stacktrace) {
      print(error);
      print(stacktrace);

      throw Exception('UNKNOWN');
    }

  }

  Future<bool> updateTeam({
    required List<int> team,
    required List<bool> isOften,
  }) async {

    try {

      List<Map<String, dynamic>> data = [];

      for(int i = 0; i < team.length; i++) {
        data.add({
          "user_id": team[i],
          "is_often": isOften[i],
        });
      }

      final response = await dio.put(
        ApiRepository.baseUrl + "employees",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${UserToken.accessToken}",
            HttpHeaders.contentTypeHeader: "application/json"
          }
        ),
        data: {
          "employees": data,
        }
      );

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else {
        return false;
      }

    } catch(e) {
      print(e);
      throw Exception('UNKNOWN');
    }

  }
}