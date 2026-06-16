String normalizeJordanianPhone(String value) {
  final digitsOnly = value.replaceAll(RegExp(r'[^0-9+]'), '');
  final cleaned = digitsOnly.startsWith('+')
      ? digitsOnly.substring(1)
      : digitsOnly;

  if (cleaned.startsWith('9627') && cleaned.length == 12) {
    return '0${cleaned.substring(3)}';
  }

  return cleaned;
}

bool isValidJordanianPhone(String value) {
  return RegExp(r'^07\d{8}$').hasMatch(value);
}
