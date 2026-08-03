import '../../../../core/error/failures.dart';

abstract class ResidentFailure extends Failure {
  const ResidentFailure({required super.message, super.statusCode});
}

class ResidentNotFoundFailure extends ResidentFailure {
  const ResidentNotFoundFailure([String message = 'Resident profile not found.']) : super(message: message);
}

class HouseNotFoundFailure extends ResidentFailure {
  const HouseNotFoundFailure([String message = 'House details not found.']) : super(message: message);
}

class ResidentServerFailure extends ResidentFailure {
  const ResidentServerFailure([String message = 'Failed to connect to resident server.']) : super(message: message);
}

class ResidentCacheFailure extends ResidentFailure {
  const ResidentCacheFailure([String message = 'Local resident cache read/write failed.']) : super(message: message);
}
