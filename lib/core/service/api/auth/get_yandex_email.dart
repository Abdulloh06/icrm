import 'dart:io';
import 'package:avlo/core/repository/api_repository.dart';
import 'package:dio/dio.dart';

class YandexAuth {

  final dio = Dio();

  Future getYandexMail() async{
    final response = await dio.get(
      ApiRepository.getYandexMail,
    );

    if(response.statusCode == HttpStatus.ok) {
      final data = response.data;

      return data;
    } else {
      throw Exception('ERROR WHILE GETTING EMAIL');
    }
  }

}