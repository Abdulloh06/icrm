/*
  Developer Muhammadjonov Abdulloh
  15 y.o
 */

import 'dart:io';

import 'package:icrm/core/models/portfolio_model.dart';
import 'package:icrm/core/repository/api_repository.dart';
import 'package:icrm/core/repository/user_token.dart';
import 'package:dio/dio.dart';

class GetPortfolio {

  final dio = Dio();

  Future<List<PortfolioModel>> getPortfolio() async {
    
    try {
      
      final response = await dio.get(
        ApiRepository.getPortfolio,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return PortfolioModel.fetchData(data);
      }else if(response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      }else {
        throw Exception(response.statusMessage);
      }

    } catch(error) {
      print(error);
      throw Exception('UNKNOWN + $error');
    }
    
  }

}