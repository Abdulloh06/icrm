/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/message_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class LeadsMessage {
  final dio = Dio();


  Future<bool> sendMessage({
    required String message,
    required dynamic user_id,
    required int lead_id,
    required dynamic client_id,
  }) async {

    try {

      Map<String, dynamic> data = {
        "lead_id": lead_id,
        "message": message,
      };
      if(user_id != null) {
        data.addAll({
          "user_id": user_id,
        });
      }
      if(client_id != null) {
        data.addAll({
          "contact_id": client_id,
        });
      }

      final response = await dio.post(
        ApiRepository.leadsMessage,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json"
          }
        ),
        data: data,
      ).timeout(const Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      if(response.statusCode == HttpStatus.created) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError){
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } on DioError catch(error) {
      print(error.response!.data);

      throw Exception('UNKNOWN');
    }
  }

  Future<List<MessageModel>> getMessages({required int lead_id}) async {

    try {

      final response = await dio.get(
        ApiRepository.leadsMessage + "?lead=$lead_id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          }
        ),
      ).timeout(const Duration(minutes: 1), onTimeout: () {
        throw Exception('TIME OUT');
      });

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return MessageModel.fetchData(data);
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

  Future<bool> deleteMessage({required int id}) async {

    try {

      final response = await dio.delete(
        ApiRepository.leadsMessage + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      if(response.statusCode == HttpStatus.noContent) {
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