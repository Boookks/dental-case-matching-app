enum AccountType {
  patient,
  dentalStudent,
}

extension AccountTypeLabel on AccountType {
  String get label {
    switch (this) {
      case AccountType.patient:
        return 'Patient';
      case AccountType.dentalStudent:
        return 'Dental Student';
    }
  }
}
