import 'dart:io';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:dio/dio.dart';

class YandexAuth {

  final dio = Dio();

  Future<Map<String, dynamic>> getYandexMail({required String token}) async{
    try {
      final response = await dio.get(
        ApiRepository.getYandexProfile + token,
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        print(data['default_email']);
        return data;
      }else {
        throw Exception('UNKNOWN');
      }

    } catch(e) {
      print(e);
      throw Exception('error');
    }
  }

}