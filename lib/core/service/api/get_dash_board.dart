import 'package:avlo/core/models/dash_board_model.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../../repository/api_repository.dart';
import '../../repository/user_token.dart';

class GetDashBoard {

  final dio = Dio();

  Future<List<DashBoardModel>> getDashBoard() async {
    try {
      final response = await dio.get(
        ApiRepository.getDashboard,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": 'Bearer ${UserToken.accessToken}',
          },
        ),
      ).timeout(const Duration(minutes: 1), onTimeout: () {
        throw (Exception('TIME OUT'));
      });

      final Map<String, dynamic> data = await response.data;

      if (response.statusCode == HttpStatus.ok) {
        return DashBoardModel.fetchData(data);
      } else if (response.statusCode == HttpStatus.internalServerError) {
        throw Exception('SERVER ERROR');
      } else {
        throw Exception('UNKNOWN');
      }
    } catch (e) {
      print(e);

      throw Exception('UNKNOWN');
    }
  }

}