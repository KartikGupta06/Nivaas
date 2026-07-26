/// Abstract Conflict Resolver interface enforcing Server-Wins / Timestamp rules.
abstract class ConflictResolver<T> {
  T resolve({required T localState, required T serverState});
}

/// Default Server-Wins Conflict Resolution Strategy implementation.
class ServerWinsConflictResolver<T> implements ConflictResolver<T> {
  @override
  T resolve({required T localState, required T serverState}) {
    // Server state always takes precedence unless explicitly overridden
    return serverState;
  }
}
