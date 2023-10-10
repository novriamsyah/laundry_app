import 'package:dartz/dartz.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/app_request.dart';
import 'package:laundry_app/config/app_response.dart';
import 'package:laundry_app/config/app_sessions.dart';
import 'package:laundry_app/config/exception_response.dart';
import 'package:http/http.dart' as http;

class PromoDatasource {
  static Future<Either<ExceptionResponse, Map>> getPromos() async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/promo/limit');
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


