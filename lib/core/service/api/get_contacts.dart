import 'dart:io';
import 'package:avlo/core/models/contacts_model.dart';
import 'package:avlo/core/repository/api_repository.dart';
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
    required File avatar,
  }) async {
    try {

      String fileName = avatar.path.split('/').last;

      FormData formData = await FormData.fromMap({
        "name": name,
        "position": position,
        "phone_number": phone_number,
        "email": email,
        "contact_type": type,
      });

      formData.files.add(MapEntry('avatar', await MultipartFile.fromFile(avatar.path, filename: fileName)));

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
        return '';
      } else {
        if(data['']) {
          return 'email_already_in_use';
        }else if(data['']) {
          return 'phone_already_in_use';
        }else {
          return "something_went_wrong";
        }
      }
    } catch (e) {
      print(e);
      throw Exception('UNKNOWN');
    }
  }

  Future<ContactModel> updateContact({
    required int id,
    required String name,
    required String position,
    required String phone_number,
    required String email,
    required int type,
    File? avatar,
    required bool hasAvatar,
  }) async {

    try {


      FormData formData = await FormData.fromMap({
        "name": name,
        "position": position,
        "phone_number": phone_number,
        "email": email,
        "contact_type": type,
      });

      if(hasAvatar) {
        String fileName = avatar!.path.split('/').last;
        formData.files.add(MapEntry('avatar', await MultipartFile.fromFile(avatar.path, filename: fileName)));
      }


      final response = await dio.post(
        ApiRepository.getContacts + "/$id?_method=PUT",
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
        return ContactModel.fromJson(data['data']);
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

  Future<ContactModel> showContact({required int id}) async {
    try {
      final response = await dio.get(
        ApiRepository.getContacts + "/$id",
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

      final Map<String, dynamic> data = await response.data;

      if (response.statusCode == HttpStatus.ok) {
        return ContactModel.fromJson(data['data']);
      } else if(response.statusCode == HttpStatus.internalServerError){
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }
    } catch (e) {
      print(e);
      throw Exception('UNKNOWN');
    }
  }

  Future<int> addContactFromProject({
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
        "position": position,
        "phone_number": phone_number,
        "email": email,
        "contact_type": type,
        "source": source,
      });

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
      } else {
        if(data['errors']['email'] != null) {
          throw Exception('email_already_in_use');
        }else if(data['errors']['phone'] != null) {
          throw Exception('phone_already_in_use');
        }else {
          throw Exception("something_went_wrong");
        }
      }
    } catch (e) {
      print(e);
      throw Exception('UNKNOWN');
    }
  }
}
