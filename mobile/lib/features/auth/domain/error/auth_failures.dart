import '../../../../core/error/failures.dart';

/// Specialized Auth Failures extending Failure.
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid mobile number or password',
    super.statusCode = 401,
  });
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({
    super.message = 'No resident or user account found for this mobile number',
    super.statusCode = 404,
  });
}

class OtpExpiredFailure extends AuthFailure {
  const OtpExpiredFailure({
    super.message = 'OTP verification code has expired',
    super.statusCode = 400,
  });
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure({
    super.message = 'Your session has expired. Please log in again.',
    super.statusCode = 401,
  });
}
