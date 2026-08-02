import '../../../../core/error/failures.dart';

class InvalidSocietyDataFailure extends ValidationFailure {
  const InvalidSocietyDataFailure({super.message = 'Invalid society setup data provided.', super.statusCode});
}

class DuplicateWingFailure extends ValidationFailure {
  const DuplicateWingFailure({super.message = 'Wing name already exists. Wing names must be unique.', super.statusCode});
}

class DuplicateHouseFailure extends ValidationFailure {
  const DuplicateHouseFailure({super.message = 'Duplicate flat number detected in house layout.', super.statusCode});
}

class InvalidFloorCountFailure extends ValidationFailure {
  const InvalidFloorCountFailure({super.message = 'Floor count must be between 1 and 100.', super.statusCode});
}

class InvalidPhoneFailure extends ValidationFailure {
  const InvalidPhoneFailure({super.message = 'Please provide a valid 10-digit Indian mobile number.', super.statusCode});
}

class EmptySocietyNameFailure extends ValidationFailure {
  const EmptySocietyNameFailure({super.message = 'Society name cannot be empty.', super.statusCode});
}

class DuplicateOwnerFailure extends ValidationFailure {
  const DuplicateOwnerFailure({super.message = 'The specified phone number is already assigned to another flat.', super.statusCode});
}

class SetupSaveFailure extends ServerFailure {
  const SetupSaveFailure({super.message = 'Failed to submit society setup configuration.', super.statusCode});
}

class DraftSaveFailure extends CacheFailure {
  const DraftSaveFailure({super.message = 'Failed to save local draft progress.', super.statusCode});
}
