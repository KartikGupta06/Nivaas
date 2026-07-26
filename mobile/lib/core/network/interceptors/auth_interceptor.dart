import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';
import '../../security/secure_storage_service.dart';

/// Dio Interceptor injecting Bearer JWT Token and X-Society-ID into HTTP headers.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getAccessToken();
    final societyId = await _secureStorage.getSocietyId();

    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.headerAuthorization] = '${ApiConstants.bearerPrefix}$token';
    }

    if (societyId != null && societyId.isNotEmpty) {
      options.headers[ApiConstants.headerSocietyId] = societyId;
    }

    options.headers[ApiConstants.headerAppVersion] = '1.0.0';

    super.onRequest(options, handler);
  }
}
