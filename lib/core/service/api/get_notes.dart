/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';
import 'package:icrm/core/service/api/get_attachment.dart';
import 'package:icrm/core/util/get_it.dart';

import '../../models/notes_model.dart';

class GetNotes {

  final dio = Dio();

  Future<List<NotesModel>> getNotes() async {

    try {

      final response = await dio.get(
        ApiRepository.getNotes,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return NotesModel.fetchData(data);
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

  Future<bool> addNotes({
    required String title,
    required String content,
    required List<String> images,
  }) async {

    try {

      final response = await dio.post(
        ApiRepository.getNotes,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
        data: {
          "title": title,
          "content": content,
        },
      ).timeout(Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.created) {
        for(int i = 0; i < images.length; i++) {
          await getIt.get<GetAttachment>().addAttachment(
            content_type: "note",
            content_id: data['data']['id'],
            file: File(images[i]),
          );
        }
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

  Future<bool> deleteNotes({
    required int id,
  }) async {

    try {

      final response = await dio.delete(
        ApiRepository.getNotes + "/$id",
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

  Future<bool> updateNotes({
    required int id,
    required String title,
    required String content,
  }) async {

    try {

      final response = await dio.put(
        ApiRepository.getNotes + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
        data: {
          "title": title,
          "content": content,
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