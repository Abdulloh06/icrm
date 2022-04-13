/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';

import 'package:icrm/core/models/projects_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:dio/dio.dart';

import '../../repository/user_token.dart';

class GetProjects {
  final dio = Dio();

  Future<List<ProjectsModel>> getProjects({required int page, bool trash = false}) async {

    try {
      final response = await dio.get(
        ApiRepository.getProjects + "?paginate=true&expand=leads.leadStatus,tasks.taskStatus,company.contact,userCategory,leads.contact,projectStatus,members&trash=$trash&page=$page",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
          },
        ),
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      final Map<String, dynamic> data = response.data;

      if(response.statusCode == HttpStatus.ok) {
        return ProjectsModel.fetchData(data);
      }else if(response.statusCode == HttpStatus.internalServerError){
        throw Exception('SERVER ERROR');
      }else {
        throw Exception(response.statusMessage);
      }
    } catch(error) {
      print(error);
      throw Exception(error);
    }

  }

  Future<ProjectsModel> addProjects({
    required String name,
    required String? description,
    required dynamic user_category_id,
    required dynamic project_status_id,
    required bool is_owner,
    required String? notify_at,
    required dynamic price,
    required String? currency,
    required dynamic companyId,
    required List<int>? members,
  }) async {



    Map<String, dynamic> formData = {
      "name": name,
      "user_category_id": user_category_id,
      "project_status_id": project_status_id,
    };


    if(description != '' && description != null) {
      formData.addAll({
        "description": description,
      });
    }
    if(notify_at != '' && notify_at != null) {
      formData.addAll({
        "notify_at": notify_at,
      });
    }
    if(companyId != null) {
      formData.addAll({
        "company_id": companyId,
      });
    }
    if(currency != null && currency != '') {
      formData.addAll({
        "currency": currency,
      });
    }
    if(price != null && price != '') {
      formData.addAll({
        "price": price.toString(),
      });
    }
    if(members != null && members.isNotEmpty) {
      formData.addAll({
        "members": members,
      });
    }


    try {
      final response = await dio.post(
        ApiRepository.getProjects,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
          },
        ),
        data: formData,
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.created) {
        return ProjectsModel.fromJson(data['data']);
      }else if(response.statusCode == HttpStatus.internalServerError){
        throw Exception('SERVER ERROR');
      }else if(response.statusCode == HttpStatus.unprocessableEntity){
        throw Exception('enter_valid_info');
      }else {
        throw Exception(response.statusMessage);
      }
    } catch(error) {
      print(error);
      throw Exception('UNKNOWN PROJECTS');
    }

  }

  Future<bool> updateProject({
    required int id,
    required String name,
    required String? description,
    required int? company_id,
    required int? user_category_id,
    required int project_status_id,
    required List<int>? members,
  }) async {

    try {

      Map<String, dynamic> formData = {
        "name": name,
        "project_status_id": project_status_id,
      };

      if(description != null && description != '') {
        formData.addAll({
          "description": description,
        });
      }
      if(company_id != null && company_id != 0) {
        formData.addAll({
          "company_id": company_id,
        });
      }
      if(user_category_id != null) {
        formData.addAll({
          "user_category_id": user_category_id,
        });
      }
      if(members != null) {
        formData.addAll({
          "members": members
        });
      }

      final response = await dio.put(
        ApiRepository.getProjects + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-type": "application/json",
          }
        ),
        data: formData,
      );

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } catch (error) {
      print(error);
      throw Exception('UNKNOWN');
    }
  }

  Future<ProjectsModel> showProject({required int id}) async {

    try {

      final response = await dio.get(
        ApiRepository.getProjects + "/$id?expand=author,projectStatus,leads,tasks.taskStatus,company.contact,members",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          }
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return ProjectsModel.fromJson(data['data']);
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(error, stackTrace) {
      print(error);
      print(stackTrace);

      throw Exception('UNKNOWN');
    }

  }

  Future<bool> deleteProject({required int id}) async {

    try {

      final response = await dio.delete(
        ApiRepository.getProjects + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json"
          },
        ),
      );

      if(response.statusCode == HttpStatus.noContent) {
        return true;
      }else if (response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        return false;
      }

    } catch (error) {
      print(error);
      throw Exception('UNKNOWN PROJECTS');
    }
  }

}