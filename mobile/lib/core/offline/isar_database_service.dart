import 'package:isar/isar.dart';

/// Singleton Service initializing and managing the local Isar Database lifecycle.
class IsarDatabaseService {
  Isar? _isar;

  Isar get database {
    if (_isar == null || !_isar!.isOpen) {
      throw StateError('Isar Database has not been initialized. Call initialize() first.');
    }
    return _isar!;
  }

  Future<void> initialize() async {
    if (_isar != null && _isar!.isOpen) return;

    // Schema collections will be registered here as feature entities are added.
    _isar = await Isar.open(
      [], // Collection schemas empty shell for architecture foundation
      directory: '', // Uses default application documents directory
      inspector: true,
    );
  }

  Future<void> close() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
    }
  }
}
