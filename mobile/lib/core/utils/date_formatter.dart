import 'package:intl/intl.dart';

/// Formatting utility converting UTC ISO dates to Indian Presentation standards.
abstract class DateFormatter {
  static final DateFormat _presentationDateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _presentationDateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _timeOnlyFormat = DateFormat('hh:mm a');

  static String formatDate(DateTime dateTime) {
    return _presentationDateFormat.format(dateTime.toLocal());
  }

  static String formatDateTime(DateTime dateTime) {
    return _presentationDateTimeFormat.format(dateTime.toLocal());
  }

  static String formatTime(DateTime dateTime) {
    return _timeOnlyFormat.format(dateTime.toLocal());
  }
}
