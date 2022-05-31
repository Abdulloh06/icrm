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

  Future<List<PortfolioModel>> getPortfolio({required int page}) async {
    
    try {
      
      final response = await dio.get(
        ApiRepository.getPortfolio + "?paginate=true&page=$page",
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${UserToken.accessToken}",
          },
        ),
      );

      final Map<String, dynamic> data = await response.data;

      if(response.statusCode == HttpStatus.ok) {
        return PortfolioModel.fetchData(data);
      } else {
        throw Exception("UNKNOWN");
      }

    } catch(error) {
      print(error);
      throw Exception("UNKNOWN");
    }
    
  }

}