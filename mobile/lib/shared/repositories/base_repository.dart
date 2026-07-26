import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';

/// Abstract Base Repository providing standardized error handling wrappers.
abstract class BaseRepository {
  Future<T> callGuard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } on CacheException catch (e) {
      throw CacheFailure(message: e.message);
    } on UnauthorizedException catch (e) {
      throw AuthFailure(message: e.message);
    } on ValidationException catch (e) {
      throw ValidationFailure(message: e.message);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }
}
