/// DTO for Phone + Password / OTP Login Request Payload.
class LoginRequest {
  final String phone;
  final String password;
  final String? otp;

  const LoginRequest({
    required this.phone,
    required this.password,
    this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
      if (otp != null) 'otp': otp,
    };
  }
}
