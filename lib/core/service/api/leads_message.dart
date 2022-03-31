import 'dart:io';
import 'package:avlo/core/models/message_model.dart';
import 'package:avlo/core/repository/api_repository.dart';
import 'package:avlo/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class LeadsMessage {
  final dio = Dio();


  Future<bool> sendMessage({
    required String message,
    required int user_id,
    required int lead_id,
    required int client_id,
  }) async {

    try {

      final response = await dio.post(
        ApiRepository.leadsMessage,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json"
          }
        ),
        data: {
          "lead_id": lead_id,
          "user_id": user_id,
          "message": message,
        },
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

    } catch(error) {
      print(error);

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