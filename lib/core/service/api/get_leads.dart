/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/leads_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:dio/dio.dart';
import '../../repository/user_token.dart';
import '../../util/get_it.dart';
import 'auth/login_service.dart';

class GetLeads {
  final dio = Dio();

  Future<List<LeadsModel>> getLeads({
    required int page,
    bool trash = false,
    bool withPagination = true,
  }) async {
    String url;
    if(withPagination) {
      url = ApiRepository.getLeads + "?paginate=true&expand=project.projectStatus,project.userCategory,project.members,label.userLabel,seller,tasks,messages,contact&trash=$trash&page=$page";
    }else {
      url = ApiRepository.getLeads + "?expand=project.projectStatus,project.userCategory,project.members,label.userLabel,seller,tasks,messages,contact&trash=$trash";
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
      );

      final Map<String, dynamic> data = await response.data;

      if (response.statusCode == HttpStatus.ok) {
        return LeadsModel.fetchData(data);
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

        return await getLeads(page: page);
      }else if(e.response!.statusCode == HttpStatus.internalServerError) {
        throw Exception("SERVER ERROR");
      }else {
        throw Exception('UNKNOWN');
      }
    }
  }

  Future<LeadsModel> addLeads({
    required int projectId,
    required dynamic contactId,
    required dynamic seller_id,
    required String? description,
    required String? estimated_amount,
    required String? startDate,
    required String? endDate,
    required int leadStatus,
    required String? currency,
  }) async {
    try {

      startDate = DateTime.now().toString();

      FormData formData = await FormData.fromMap({
        "project_id": projectId,
        "start_date": startDate,
        "label_id": leadStatus,
        "contact_id": contactId,
      });

      if(endDate != '' && endDate != null) {
        formData.fields.add(MapEntry('end_date', endDate));
      }
      if(currency != null && currency != '') {
        formData.fields.add(MapEntry('currency', currency));
      }
      if(seller_id != null) {
        formData.fields.add(MapEntry('seller_id', seller_id.toString()));
      }
      if(description != null && description != '') {
        formData.fields.add(MapEntry('description', description));
      }
      if(estimated_amount != null) {
        formData.fields.add(MapEntry('estimated_amount', estimated_amount.toString()));
      }


      final response = await dio.post(
        ApiRepository.getLeads,
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
        return LeadsModel.fromJson(data['data']);
      } else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }
    } on DioError catch (e) {
      final Map<String, dynamic> data = await e.response!.data;
      print(data);
      throw Exception('UNKNOWN ADD LEADS $e');
    }
  }

  Future<LeadsModel> showLeads({required int id}) async {
    try {
      final response = await dio
          .get(
        ApiRepository.getLeads + "/$id?expand=project.projectStatus,project.userCategory,project.members,leadStatus,seller,tasks.taskStatus,contact",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if (response.statusCode == HttpStatus.ok) {
        return LeadsModel.fromJson(data['data']);
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

  Future<String> updateLeads({
    required int id,
    required int projectId,
    required dynamic contactId,
    required dynamic estimatedAmount,
    required String? startDate,
    required String? endDate,
    required int leadStatusId,
    required int? seller_id,
    required String? description,
    required String? currency,
  }) async {
    try {
      startDate = DateTime.now().toString();

      Map<String, dynamic> formData = {
        "project_id": projectId,
        "label_id": leadStatusId,
        "contact_id": contactId,
      };

      if(endDate != '' && endDate != null) {
        formData.addAll({
          "end_date": endDate,
        });
      }
      if(currency != null && currency != '') {
        formData.addAll({
          "currency": currency,
        });
      }
      if(estimatedAmount != null && estimatedAmount != '') {
        formData.addAll({
          "estimated_amount": estimatedAmount,
        });
      }
      if(description != null && description != '') {
        formData.addAll({
          "description": description,
        });
      }
      if(seller_id != null) {
        formData.addAll({
          "seller_id": seller_id,
        });
      }

      final response = await dio.put(
        ApiRepository.getLeads + "/$id",
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

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        return '';
      } else if (response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        return response.statusMessage.toString();
      }
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);

      throw Exception('UNKNOWN');
    }
  }

  Future<bool> deleteLeads({required int id}) async {
    try {
      final response = await dio
          .delete(
        ApiRepository.getLeads + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
          },
        ),
      )
          .timeout(const Duration(minutes: 1), onTimeout: () {
        throw (Exception('TIME OUT'));
      });

      if (response.statusCode == HttpStatus.noContent) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw Exception('UNKNOWN');
    }
  }
}
