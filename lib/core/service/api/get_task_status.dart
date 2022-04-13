/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/tasks_status_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class GetTasksStatus {

  final dio = Dio();

  Future<List<TaskStatusModel>> getTaskStatuses() async {

    try {

      final response = await dio.get(
        ApiRepository.getTaskStatuses,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return TaskStatusModel.fetchData(data);
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

  Future<bool> addTaskStatus({required String name}) async {

    try {

      final response = await dio.post(
          ApiRepository.getTaskStatuses,
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

  Future<bool> deleteTaskStatus({required int id}) async {

    try {

      final response = await dio.delete(
        ApiRepository.getTaskStatuses + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      if(response.statusCode == HttpStatus.noContent) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }

    }catch (error) {
      print(error);
      throw Exception('UNKNOWN ERROR');
    }

  }

  Future<bool> updateProjectStatus({required int id, required String name}) async {

    try {

      final response = await dio.put(
        ApiRepository.getTaskStatuses+ "/$id",
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