import 'package:dartz/dartz.dart';
import 'package:laundry_app/config/app_constants.dart';
import 'package:laundry_app/config/app_request.dart';
import 'package:laundry_app/config/app_response.dart';
import 'package:laundry_app/config/app_sessions.dart';
import 'package:laundry_app/config/exception_response.dart';
import 'package:http/http.dart' as http;
import 'package:laundry_app/data/models/response/user_model.dart';

class LaundryDatasource {
  Future<Either<ExceptionResponse, Map>> readByUser(int userId) async {
    final url = Uri.parse('${AppConstants.baseUrl}/laundry/user/$userId');
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

   static Future<Either<ExceptionResponse, Map>> claim(String id, String claimCode) async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/laundry/claim');
    UserModel? user = await AppSessions.getUser();
    final token = await AppSessions.getBearerToken();
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'id': id,
          'claim_code': claimCode,
          'user_id': user!.id.toString(),
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
