/// Exception classes thrown at data source layers.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'No active internet connection available'});

  @override
  String toString() => 'NetworkException(message: $message)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = 'Session expired. Please log in again.'});

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}

class ValidationException implements Exception {
  final String message;

  const ValidationException({required this.message});

  @override
  String toString() => 'ValidationException(message: $message)';
}
