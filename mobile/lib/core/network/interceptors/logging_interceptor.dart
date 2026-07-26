import 'package:dio/dio.dart';
import '../../logging/logger_service.dart';

/// Dio Logging Interceptor outputting formatted request/response events.
class LoggingInterceptor extends Interceptor {
  final LoggerService _logger;

  LoggingInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.info('HTTP Request [${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _logger.info('HTTP Response [${response.statusCode}] <= PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error('HTTP Error [${err.response?.statusCode}] <= ${err.requestOptions.path}: ${err.message}');
    super.onError(err, handler);
  }
}
