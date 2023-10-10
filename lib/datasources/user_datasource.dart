import 'package:dartz/dartz.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/app_request.dart';
import 'package:laundry_app/config/app_response.dart';
import 'package:laundry_app/config/exception_response.dart';
import 'package:http/http.dart' as http;

class UserDatasource {
  static Future<Either<ExceptionResponse, Map>> login(
    String email,
    String password,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'email': email,
          'password': password,
        },
      );

      final result = AppResponse.data(response);
      return Right(result);
    } catch (e) {
      if (e is ExceptionResponse) {
        return Left(e);
      }

      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<ExceptionResponse, Map>> register(
    String username,
    String email,
    String password,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/register');

    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {
          'username': username,
          'email': email,
          'password': password,
        },
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
