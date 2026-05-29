class AppUtils {
  static String formatRoleLabel(String role) {
    if (role.isEmpty) {
      return 'Unknown';
    }

    return role[0].toUpperCase() + role.substring(1);
  }

  static String trimWithEllipsis(String value, {int maxLength = 60}) {
    if (value.length <= maxLength) {
      return value;
    }

    return '${value.substring(0, maxLength).trimRight()}...';
  }
}
