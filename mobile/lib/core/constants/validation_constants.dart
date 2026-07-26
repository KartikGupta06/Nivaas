/// Validation Regex Patterns and Messages.
abstract class ValidationConstants {
  static final RegExp indianPhoneRegex = RegExp(r'^[6-9]\d{9}$');
  static final RegExp otpRegex = RegExp(r'^\d{6}$');
  static final RegExp flatNumberRegex = RegExp(r'^[A-Z0-9\-\s]{1,10}$', caseSensitive: false);

  static const String invalidPhoneMsg = 'Enter a valid 10-digit Indian mobile number';
  static const String invalidOtpMsg = 'Enter a valid 6-digit OTP code';
  static const String requiredFieldMsg = 'This field is required';
}
