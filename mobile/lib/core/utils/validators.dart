import '../constants/validation_constants.dart';

/// Form Field Input Validators.
abstract class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationConstants.requiredFieldMsg;
    }
    final cleanPhone = value.replaceAll(RegExp(r'\D'), '');
    if (!ValidationConstants.indianPhoneRegex.hasMatch(cleanPhone)) {
      return ValidationConstants.invalidPhoneMsg;
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationConstants.requiredFieldMsg;
    }
    if (!ValidationConstants.otpRegex.hasMatch(value.trim())) {
      return ValidationConstants.invalidOtpMsg;
    }
    return null;
  }

  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : ValidationConstants.requiredFieldMsg;
    }
    return null;
  }
}
