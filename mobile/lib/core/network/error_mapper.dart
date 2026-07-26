import 'package:dio/dio.dart';
import '../error/failures.dart';

/// Maps DioException objects to Domain Failure instances.
abstract class ErrorMapper {
  static Failure mapDioExceptionToFailure(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'Connection timed out. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        final responseData = exception.response?.data;
        String message = 'Server returned error code $statusCode';

        if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
          message = responseData['message'] as String;
        }

        if (statusCode == 401 || statusCode == 403) {
          return AuthFailure(message: message, statusCode: statusCode);
        }

        if (statusCode == 422) {
          return ValidationFailure(message: message, statusCode: statusCode);
        }

        return ServerFailure(message: message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const UnexpectedFailure(message: 'Request was cancelled');

      default:
        return const UnexpectedFailure(message: 'An unexpected network error occurred');
    }
  }
}
