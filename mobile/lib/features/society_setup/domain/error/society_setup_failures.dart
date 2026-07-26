import '../../../../core/error/failures.dart';

class InvalidSocietyDataFailure extends ValidationFailure {
  const InvalidSocietyDataFailure({
    super.message = 'Invalid society configuration or duplicate wing name',
  });
}

class SetupSaveFailure extends ServerFailure {
  const SetupSaveFailure({
    super.message = 'Failed to save society onboarding layout',
  });
}
