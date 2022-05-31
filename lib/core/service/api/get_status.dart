/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/status_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class GetStatus {
  final dio = Dio();

  Future<List<StatusModel>> getStatus({required String type}) async {

    try {

      final response = await dio.get(
        ApiRepository.baseUrl + "$type-labels",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return StatusModel.fetchData(data);
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

  Future<bool> updateStatus({
    required int id,
    required String name,
    required String type,
    required String color,
  }) async {
    try {

      final response = await dio.post(
        ApiRepository.baseUrl + "$type-labels",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),
        data: {
          "label_id": id,
          "id": id,
          "name": name,
          "color": color,
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

  Future<bool> deleteStatus({
    required int id,
    required String type,
  }) async {

    try {
      final response = await dio.delete(
        ApiRepository.baseUrl + "$type-labels/$id",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${UserToken.accessToken}",
            HttpHeaders.contentTypeHeader: "application/json",
          }
        ),
      );

      if(response.statusCode == HttpStatus.noContent) {
        return true;
      }else {
        return false;
      }
    } catch(e) {
      print(e);
      throw Exception('UNKNOWN');
    }
  }

}
