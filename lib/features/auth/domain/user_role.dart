enum UserRole { patient, driver, hospital }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.patient => 'Patient',
    UserRole.driver => 'Driver',
    UserRole.hospital => 'Hospital',
  };

  static UserRole? fromStorage(String? raw) {
    switch (raw) {
      case 'patient':
        return UserRole.patient;
      case 'driver':
        return UserRole.driver;
      case 'hospital':
        return UserRole.hospital;
      default:
        return null;
    }
  }

  String get storageValue => name;
}
