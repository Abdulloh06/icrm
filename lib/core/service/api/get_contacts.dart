/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/contacts_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:dio/dio.dart';
import '../../repository/user_token.dart';

class GetContacts {
  final dio = Dio();

  Future<List<ContactModel>> getContacts() async {
    try {
      final response = await dio.get(
        ApiRepository.getContacts,
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
        return ContactModel.fetchData(data);
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

  Future<String> addContact({
    required String name,
    required String position,
    required String phone_number,
    required String email,
    required int type,
    required File? avatar,
  }) async {
    try {

      FormData formData = await FormData.fromMap({
        "name": name,
        "contact_type": type,
      });
      if(phone_number.isNotEmpty) {
        formData.fields.add(MapEntry("phone_number", phone_number));
      }
      if(email != '') {
        formData.fields.add(MapEntry('email', email));
      }
      if(position != '') {
        formData.fields.add(MapEntry('position', position));
      }

      if(avatar != null) {
        String fileName = avatar.path.split('/').last;
        formData.files.add(MapEntry('avatar', await MultipartFile.fromFile(avatar.path, filename: fileName)));
      }
      final response = await dio.post(
        ApiRepository.getContacts,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: 'Bearer ${UserToken.accessToken}',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: formData,
      ).timeout(const Duration(minutes: 1), onTimeout: () {
        throw (Exception('TIME OUT'));
      });

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return '';
      } else {
        return 'something_went_wrong';
      }
    } on DioError catch (e) {
      final Map<String, dynamic> data = await e.response!.data;

      if(data['errors']['email'] != null) {
        return 'email_already_in_use';
      }else if(data['errors']['phone_number'] != null
          && data['errors']['phone_number'].toString()
              .contains('The phone number must be at least 12 characters')
      ) {
        return 'invalid_phone_number';
      }else if(data['errors']['phone_number'] != null) {
        return "phone_already_in_use";
      }else {
        return "something_went_wrong";
      }
    }
  }

  Future<bool> updateContact({
    required int id,
    required String name,
    required String position,
    required String phone_number,
    required String email,
    required int type,
    File? avatar,
  }) async {

    try {

      FormData formData = await FormData.fromMap({
        "name": name,
        "phone_number": phone_number,
        "contact_type": type,
      });

      if(position.isNotEmpty) {
        formData.fields.add(MapEntry('position', position));
      }
      if(email.isNotEmpty) {
        formData.fields.add(MapEntry('email', email));
      }
      if(avatar != null) {
        String fileName = avatar.path.split('/').last;
        formData.files.add(MapEntry('avatar', await MultipartFile.fromFile(avatar.path, filename: fileName)));
      }

      final response = await dio.post(
        ApiRepository.getContacts + "/$id?_method=PUT",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
        data: formData,
      );

      if(response.statusCode == HttpStatus.ok) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception(response.statusMessage);
      }

    } catch(error) {
      print(error);
      throw Exception('ERROR');
    }
  }

  Future<bool> deleteContact({required String id}) async {
    try {
      final response = await dio.delete(
        ApiRepository.getContacts + "/"+ id,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
          },
        ),
      ).timeout(const Duration(minutes: 1), onTimeout: () {
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

  Future addContactFromProject({
    required String name,
    required String position,
    required String phone_number,
    required String email,
    required int type,
    required int source,
  }) async {
    try {


      FormData formData = await FormData.fromMap({
        "name": name,
        "contact_type": type,
        "source": source,
      });
      if(phone_number.isNotEmpty) {
        formData.fields.add(MapEntry("phone_number", phone_number));
    }
      if(email != '') {
        formData.fields.add(MapEntry('email', email));
      }
      if(position != '') {
        formData.fields.add(MapEntry('position', position));
      }

      final response = await dio.post(
        ApiRepository.getContacts,
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
        return data['data']['id'];
      }else {
        return "something_went_wrong";
      }
    } on DioError catch (e) {
      final Map<String, dynamic> data = await e.response!.data;
      print(data);

      if(data['errors']['email'] != null) {
        return 'email_already_in_use';
      }else if(data['errors']['phone_number'] != null && data['errors']['phone_number'].toString().contains('The phone number must be at least 12 characters')) {
        return 'invalid_phone_number';
      }else if(data['errors']['phone_number'] != null) {
        return "phone_already_in_use";
      }else {
        return "something_went_wrong";
      }
    }
  }
}
