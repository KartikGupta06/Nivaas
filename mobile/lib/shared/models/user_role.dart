/// Supported User Roles in Nivaas System architecture.
enum UserRole {
  none,
  superAdmin,
  societyAdmin,
  resident,
  watchman,
}

extension UserRoleX on UserRole {
  String get nameString {
    switch (this) {
      case UserRole.superAdmin:
        return 'SUPER_ADMIN';
      case UserRole.societyAdmin:
        return 'SOCIETY_ADMIN';
      case UserRole.resident:
        return 'RESIDENT';
      case UserRole.watchman:
        return 'WATCHMAN';
      case UserRole.none:
        return 'NONE';
    }
  }

  static UserRole fromString(String value) {
    switch (value.toUpperCase()) {
      case 'SUPER_ADMIN':
        return UserRole.superAdmin;
      case 'SOCIETY_ADMIN':
        return UserRole.societyAdmin;
      case 'RESIDENT':
        return UserRole.resident;
      case 'WATCHMAN':
        return UserRole.watchman;
      default:
        return UserRole.none;
    }
  }
}
