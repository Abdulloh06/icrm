/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/leads_status_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class GetLeadsStatus {
  final dio = Dio();

  Future<List<LeadsStatusModel>> getLeadsStatus() async {

    try {

      final response = await dio.get(
        ApiRepository.getLeadsStatus,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return LeadsStatusModel.fetchData(data);
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


  Future<LeadsStatusModel> showLeadStatus({required int id}) async {

    try {

      final response = await dio.get(
        ApiRepository.getLeadsStatus + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return LeadsStatusModel.fromJson(data['data']);
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

  Future<bool> addLeadsStatus({required String name}) async {

    try {

      final response = await dio.post(
        ApiRepository.getLeadsStatus,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),
        data: {
          "name": name,
        }
      );

      if(response.statusCode == HttpStatus.created) {
        return true;
      }else if(response.statusCode == HttpStatus.internalServerError){
        throw Exception('SERVER ERROR');
      }else {
        throw Exception(response.statusMessage);
      }

    } catch(error) {
      print(error);

      throw Exception('UNKNOWN');
    }

  }

  Future<bool> updateLeadsStatus({required int id,required String name}) async {

    try {

      final response = await dio.put(
        ApiRepository.getLeadsStatus + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          }
        ),
        data: {
          "name": name,
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

  Future<bool> deleteLeadsStatus({required int id}) async {

    try {

      final response = await dio.delete(
        ApiRepository.getLeadsStatus + "/$id",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
            "Content-Type": "application/json",
          },
        ),
      );

      if(response.statusCode == HttpStatus.noContent) {
        return true;
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(error) {
      print(error);

      throw Exception('UNKNOWN');
    }

  }
}
