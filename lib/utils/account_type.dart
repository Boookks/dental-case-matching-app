enum AccountType { patient, dentalStudent }

extension AccountTypeLabel on AccountType {
  String get storageValue {
    switch (this) {
      case AccountType.patient:
        return 'patient';
      case AccountType.dentalStudent:
        return 'dentalStudent';
    }
  }

  String get label {
    switch (this) {
      case AccountType.patient:
        return 'Patient';
      case AccountType.dentalStudent:
        return 'Dental Student';
    }
  }
}

AccountType? accountTypeFromStorage(String value) {
  switch (value) {
    case 'patient':
      return AccountType.patient;
    case 'dentalStudent':
      return AccountType.dentalStudent;
    default:
      return null;
  }
}
