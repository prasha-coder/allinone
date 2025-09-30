enum UserRole {
  doctor,
  patient,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.patient:
        return 'Patient';
    }
  }

  String get description {
    switch (this) {
      case UserRole.doctor:
        return 'Healthcare Professional';
      case UserRole.patient:
        return 'Patient/Client';
    }
  }

  String get icon {
    switch (this) {
      case UserRole.doctor:
        return '👨‍⚕️';
      case UserRole.patient:
        return '👤';
    }
  }
}
