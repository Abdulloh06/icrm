/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */


import 'dart:io';

import 'package:icrm/core/models/comments_model.dart';
import 'package:icrm/core/models/tasks_model.dart';
import 'package:dio/dio.dart';
import '../../repository/api_repository.dart';
import '../../repository/user_token.dart';
import '../../util/get_it.dart';
import 'auth/login_service.dart';

class GetTasks {
  final dio = Dio();

  Future<List<TasksModel>> getTasks({
    required int page,
    bool trash = false,
    bool withPagination = true,
  }) async {
    String url;
    if(withPagination) {
      url = ApiRepository.getTasks + "?paginate=true&expand=comments,label.userLabel,children,assigns&trash=$trash&page=$page";
    } else {
      url = ApiRepository.getTasks + "?expand=label.userLabel,assigns&trash=$trash";
    }

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: 'Bearer ${UserToken.accessToken}',
          },
        ),
      ).timeout(const Duration(minutes: 1), onTimeout: () {
        throw (Exception('TIME OUT'));
      });

      final Map<String, dynamic> data = await response.data;

      if (response.statusCode == HttpStatus.ok) {
        return TasksModel.fetchData(data);
      } else {
        throw Exception('UNKNOWN');
      }
    } on DioError catch (e) {
      if(e.response!.statusCode == HttpStatus.unauthorized) {
        String result = await getIt.get<LoginService>().login(
          username: '',
          password: '',
          toRefresh: true,
        );
        print(result + "-Refresh Token");

        return await getTasks(page: page);
      }else if(e.response!.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception("UNKNOWN");
      }
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
    required List<int>? user,
  }) async {
    try {

      start_date = DateTime.now().toString();

      Map<String, dynamic> formData = {
        "name": name,
        "priority": priority,
        "label_id": status,
        "taskable_type": taskType,
        "taskable_id": taskId,
        "start_date": start_date,
      };

      if(parent_id != null) {
        formData.addAll({
          "parent_id": parent_id,
        });
      }
      if(deadline != '') {
        formData.addAll({
          "deadline": deadline,
        });
      }
      if(description != '') {
        formData.addAll({
          "description": description,
        });
      }
      if(user != null && user.isNotEmpty) {
        formData.addAll({
          "users": user,
        });
      }


      final response = await dio.post(
        ApiRepository.getTasks,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
            "Content-Type": "application/json",
          },
        ),
        data: formData,
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
    } on DioError catch (e) {
      print(e.response!.data);
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

  Future<bool> updateTasks({
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

      Map<String, dynamic> data = {
        "label_id": status,
        "priority": priority,
        "name": name,
        "taskable_type": taskType.split("\\").last.toLowerCase(),
        "taskable_id": taskId,
      };

      if(description.isNotEmpty) {
        data.addAll({
          "description": description,
        });
      }
      if(start_date.isNotEmpty) {
        data.addAll({
          "start_date": start_date,
        });
      }
      if(deadline.isNotEmpty) {
        data.addAll({
          "deadline": deadline,
        });
      }

      final response = await dio.put(
        ApiRepository.getTasks + "/$id",
        options: Options(
          headers: {
           "Accept": "application/json",
           "Authorization": "Bearer ${UserToken.accessToken}",
           "Content-Type": "application/json",
          }
        ),
        data: data,
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
      throw Exception('UNKNOWN UPDATE TASK $error');
    }

  }

  Future<CommentsModel> addComment({
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

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.created) {
        return CommentsModel.fromJson(data['data']);
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

  Future<bool> reassignUser({
    required int user_id,
    required int task_id,
  }) async {

    try {
      final response = await dio.post(
        ApiRepository.baseUrl + "task-user-reassign",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),
        data: {
          "task_id": task_id,
          "user_id": user_id,
        }
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
