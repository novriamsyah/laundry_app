import 'package:dartz/dartz.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/app_request.dart';
import 'package:laundry_app/config/app_response.dart';
import 'package:laundry_app/config/app_sessions.dart';
import 'package:laundry_app/config/exception_response.dart';
import 'package:http/http.dart' as http;

class ShopDatasource {
  static Future<Either<ExceptionResponse, Map>> getRecommendLimit() async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/shop/recommend');
    final token = await AppSessions.getBearerToken();

    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );

      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is ExceptionResponse) {
        return Left(e);
      }

      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<ExceptionResponse, Map>> getSearchByCity(
    String cityName,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/shop/search/city/$cityName');
    final token = await AppSessions.getBearerToken();

    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );

      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is ExceptionResponse) {
        return Left(e);
      }

      return Left(FetchFailure(e.toString()));
    }
  }
}
