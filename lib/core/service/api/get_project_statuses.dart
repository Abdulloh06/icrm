import 'dart:io';

import 'package:avlo/core/models/project_statuses_model.dart';
import 'package:avlo/core/repository/api_repository.dart';
import 'package:avlo/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class GetProjectStatuses {

  final dio = Dio();

  Future<List<ProjectStatusesModel>> getProjectStatuses() async {

    try {

      final response = await dio.get(
        ApiRepository.getProjectStatuses,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return ProjectStatusesModel.fetchData(data);
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception(response.statusMessage);
      }

    } catch(error) {
      print(error);
      throw Exception(error);
    }

  }

  Future<bool> addProjectStatus({required String name}) async {

    try {

      final response = await dio.post(
        ApiRepository.getProjectStatuses,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
        data: {
          "name": name,
        }
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      if(response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }

    }catch (error) {
      print(error);
      throw Exception('UNKNOWN');
    }

  }

  Future<bool> deleteProjectStatus({required int id}) async {

    try {

      final response = await dio.delete(
        ApiRepository.getProjectStatuses + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }

    }catch (error) {
      print(error);
      throw Exception('UNKNOWN');
    }

  }

  Future<bool> updateProjectStatus({required int id, required String name}) async {

    try {

      final response = await dio.put(
        ApiRepository.getProjectStatuses + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
        data: {
          "name": name,
        },
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }

    }catch (error) {
      print(error);
      throw Exception('UNKNOWN');
    }

  }

}