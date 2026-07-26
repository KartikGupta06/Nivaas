/// Generic ApiResponse envelope matching Nivaas FastAPI backend standard.
class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;
  final Map<String, dynamic>? error;
  final String timestamp;

  const ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.error,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 500,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T?,
      error: json['error'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}
