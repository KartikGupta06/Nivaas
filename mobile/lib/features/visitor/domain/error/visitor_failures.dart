import '../../../../core/error/failures.dart';

abstract class VisitorFailure extends Failure {
  const VisitorFailure({required super.message, super.statusCode});
}

class VisitorNotFoundFailure extends VisitorFailure {
  const VisitorNotFoundFailure([String message = 'Visitor log entry not found.']) : super(message: message);
}

class DuplicateVisitorFailure extends VisitorFailure {
  const DuplicateVisitorFailure([String message = 'Active visitor entry already exists for this flat.']) : super(message: message);
}

class InvalidFlatFailure extends VisitorFailure {
  const InvalidFlatFailure([String message = 'Target flat number is invalid or unassigned.']) : super(message: message);
}

class InvalidPhoneFailure extends VisitorFailure {
  const InvalidPhoneFailure([String message = 'Mobile number must be a valid 10-digit Indian phone number.']) : super(message: message);
}
