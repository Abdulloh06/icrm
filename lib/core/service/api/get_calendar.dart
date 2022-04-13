/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';
import 'package:icrm/core/models/calendar_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class GetCalendar {
  final dio = Dio();

  Future<CalendarModel> getCalendar({required String date}) async {

    try {

      final response = await dio.get(
        ApiRepository.getCalendar + "?date=$date",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return CalendarModel.fromJson(data['data']);
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(error) {
      print(error);

      throw Exception('UNKNOWN' + error.toString());
    }

  }

}