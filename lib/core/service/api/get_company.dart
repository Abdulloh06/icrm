/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/company_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:dio/dio.dart';
import '../../repository/user_token.dart';

class GetCompany {
  final dio = Dio();

  Future<List<CompanyModel>> getCompany() async {
    try {
      final response = await dio.get(
        ApiRepository.getCompany + "?expand=contact",
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
        return CompanyModel.fetchData(data);
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


  Future<CompanyModel> showCompany({required int id}) async {
    try {
      final response = await dio.get(
        ApiRepository.getCompany + "/$id?expand=contact",
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
        return CompanyModel.fromJson(data['data']);
      } else if (response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }
    } on DioError catch (e) {
      print(e.error);
      throw Exception('UNKNOWN');
    }
  }

  Future addCompany({
    required String name,
    required File? logo,
    required int? contactId,
    required String? url,
    required String description,
  }) async {
    try {

      FormData formData = await FormData.fromMap({
        "name": name,
        "description": description,
      });

      if(url != null && url != '') {
        formData.fields.add(MapEntry('site_url', url));
      }
      if(contactId != null) {
        formData.fields.add(MapEntry('main_contact_id', contactId.toString()));
      }
      if(logo != null) {
        String fileName = logo.path.split('/').last;
        formData.files.add(MapEntry('logo', await MultipartFile.fromFile(logo.path, filename: fileName)));
      }
      print(formData.fields);

      final response = await dio.post(
        ApiRepository.getCompany,
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
        return CompanyModel.fromJson(data['data']);
      } else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }
    } on DioError catch (e) {
      final Map<String, dynamic> error = await e.response!.data;

      if(error['errors']['name'] != null) {
        return "name_already_in_use";
      }else {
        throw Exception('UNKNOWN');
      }
    }
  }

  Future<CompanyModel> updateCompany({
    required int id,
    required String name,
    required String description,
    required String? site_url,
    required File? logo,
    required int? contact_id,
  }) async {

    try {

      FormData formData = await FormData.fromMap({
        "name": name,
        "description": description,
      });

      if(site_url != null && site_url != '') {
        formData.fields.add(MapEntry('site_url', site_url));
      }
      if(contact_id != null) {
        formData.fields.add(MapEntry('main_contact_id', contact_id.toString()));
      }
      if(logo != null) {
        String fileName = logo.path.split('/').last;
        formData.files.add(MapEntry('logo', await MultipartFile.fromFile(logo.path, filename: fileName)));
      }

      final response = await dio.post(
        ApiRepository.getCompany + "/$id?_method=PUT",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          },
        ),
        data: formData,
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return CompanyModel.fromJson(data['data']);
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


}
