/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';

import 'package:icrm/core/models/attachment_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class GetAttachment {

  final dio = Dio();

  Future<bool> addAttachment({
    required String content_type,
    required int content_id,
    required File file,
  }) async {

    String fileName = file.path.split('/').last;

    FormData formData = new FormData.fromMap(
      {
        "content_type": content_type,
        "content_id": content_id,
      }
    );


    formData.files.add(MapEntry('file', await MultipartFile.fromFile(file.path, filename: fileName)));

    try {
      final response = await dio.post(
        ApiRepository.getAttachment,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json"
          },
        ),
        data: formData,
      );

      if(response.statusCode == HttpStatus.created) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError){
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }


    } catch (error) {
      print(error);
      throw Exception("UNKNOWN ATTACHMENT + $error");
    }

  }

  Future<bool> deleteAttachment({required int id}) async {

    try {

      final response = await dio.delete(
        ApiRepository.getAttachment + "/$id",
        options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer ${UserToken.accessToken}"
            }
        ),
      );


      if(response.statusCode == HttpStatus.noContent) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception(response.statusMessage);
      }

    } catch (error) {
      print(error);
      throw Exception('UNKNOWN');
    }

  }

  Future<List<AttachmentModel>> showContentAttachment({
    required String content_type,
    required int id,
  }) async {

    try {

      final response = await dio.get(
        ApiRepository.baseUrl + "content-attachments?content_type=$content_type&content_id=$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          },
        ),
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return AttachmentModel.showContent(data);
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception(response.statusMessage);
      }

    } catch (error) {
      print(error);

      throw Exception('ERROR UNKNOWN');
    }
  }

}