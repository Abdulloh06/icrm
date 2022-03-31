import 'dart:io';

import 'package:avlo/core/models/tasks_model.dart';
import 'package:avlo/core/models/user_model.dart';
import 'package:dio/dio.dart';

import '../../repository/api_repository.dart';
import '../../repository/user_token.dart';

class GetTasks {
  final dio = Dio();

  Future<List<TasksModel>> getTasks() async {
    try {
      final response = await dio
          .get(
        ApiRepository.getTasks + "?expand=comments,taskStatus,children,assigns",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
          },
        ),
      ).timeout(const Duration(minutes: 1), onTimeout: () {
        throw (Exception('TIME OUT'));
      });

      final Map<String, dynamic> data = await response.data;


      if (response.statusCode == HttpStatus.ok) {
        return TasksModel.fetchData(data);
      } else if (response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }
    } catch (e) {
      print(e);
      throw Exception('UNKNOWN');
    }
  }

  Future<TasksModel> addTasks({
    dynamic parent_id,
    required int status,
    required int priority,
    required String start_date,
    required String deadline,
    required String name,
    required String description,
    required String taskType,
    required int taskId,
    required List<int> user,
  }) async {
    try {

      final response = await dio.post(
        ApiRepository.getTasks,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
            "Content-Type": "application/json",
          },
        ),
        data: parent_id != null ? {
          "parent_id": parent_id,
          "priority": priority,
          "task_status_id": status,
          "start_date": start_date,
          "deadline": deadline,
          "name": name,
          "description": description,
          "taskable_type": taskType,
          "taskable_id": taskId,
          "users": user,
        } : {
          "priority": priority,
          "task_status_id": status,
          "start_date": start_date,
          "deadline": deadline,
          "name": name,
          "description": description,
          "taskable_type": taskType,
          "taskable_id": taskId,
          "users": user,
        },
      ).timeout(const Duration(minutes: 1), onTimeout: () {
        throw (Exception('TIME OUT'));
      });

      final Map<String, dynamic> data = await response.data;

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return TasksModel.fromJson(data['data']);
      } else {
        if (data['errors']['email'] != null) {
          throw Exception('email');
        } else if (data['errors']['phone_number'] != null) {
          throw Exception('PHONE');
        } else {
          throw Exception('something_went_wrong');
        }
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      throw Exception('UNKNOWN');
    }
  }

  Future<TasksModel> showTask({required int id}) async {

    try {

      final response = await dio.get(
        ApiRepository.getTasks + "/$id?expand=children,assigns,taskStatus,comments",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          }
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return TasksModel.fromJson(data['data']);
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

  Future<bool> deleteTask({required int id}) async {
    try {
      final response = await dio.delete(
        ApiRepository.getTasks + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == HttpStatus.noContent) {
        return true;
      } else if (response.statusCode == HttpStatus.internalServerError) {
        throw Exception("SERVER ERROR");
      } else {
        throw Exception("UNKNOWN");
      }
    } catch (error) {
      print(error);

      throw Exception("UNKNOWN TASK + $error");
    }
  }

  Future<int> updateTasks({
    required int id,
    required dynamic parent_id,
    required String name,
    required String description,
    required int status,
    required String start_date,
    required String deadline,
    required String taskType,
    required int taskId,
    required int priority,
  }) async {

    try {
      print(taskType.split("\\").last.toLowerCase());

      final response = await dio.put(
        ApiRepository.getTasks + "/$id",
        options: Options(
          headers: {
           "Accept": "application/json",
           "Authorization": "Bearer ${UserToken.accessToken}",
           "Content-Type": "application/json",
          }
        ),
        data: {
          "task_status_id": status,
          "priority": priority,
          "start_date": start_date,
          "deadline": deadline,
          "name": name,
          "description": description,
          "taskable_type": taskType.split("\\").last.toLowerCase(),
          "taskable_id": taskId,
        }
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return data['data']['id'];
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(error) {
      print(error);
      throw Exception('UNKNOWN UPDATE TASK $error');
    }

  }

  Future<bool> addComment({
    required int id,
    required String comment,
    required String comment_type,
  }) async {

    try {

      final response = await dio.post(
        ApiRepository.getTasks + "/$id/comment",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),

        data: {
          "content": comment,
          "comment_type": comment_type,
        }
      );

      if(response.statusCode == HttpStatus.created) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }
    } catch(error) {
      print(error);

      throw Exception('UNKNOWN COMMENT $error');
    }

  }

  Future<bool> assignMembers({
    required int id,
    required List<int> users,
  }) async {

    try {
      final response = await dio.post(
        ApiRepository.task_users,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),
        data: {
          "task_id": id,
          "users": users,
        }
      );

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(error) {
      print(error);

      throw Exception('UNKNOWN');
    }
  }

  Future<List<UserModel>> users({required int id}) async {

    try {

      final response = await dio.get(
        ApiRepository.task_users + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          }
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return UserModel.fetchData(data);
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(error) {
      print(error);

      throw Exception('UNKNOWN');
    }
  }

  Future<bool> reassignUser({required int id}) async {

    try {
      final response = await dio.post(
        ApiRepository.task_users + "-reassign",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),
      );

      if(response.statusCode == HttpStatus.noContent || response.statusCode == HttpStatus.ok) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
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
