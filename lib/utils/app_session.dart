import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/utils/account_type.dart';

class AppSession {
  AppSession._();

  static AccountType? accountType;
  static String? patientPhoneNumber;

  static String routeAfterLogin() {
    switch (accountType) {
      case AccountType.dentalStudent:
        return AppRoutes.studentHome;
      case AccountType.patient:
        return patientPhoneNumber?.trim().isNotEmpty ?? false
            ? AppRoutes.patientHome
            : AppRoutes.patientContactInfo;
      case null:
        return AppRoutes.chooseAccountType;
    }
  }

  static void setAccountType(AccountType type) {
    accountType = type;
  }

  static void setPatientPhoneNumber(String? phoneNumber) {
    patientPhoneNumber = phoneNumber;
  }

  static void clearAccountType() {
    accountType = null;
  }

  static void clearSession() {
    accountType = null;
    patientPhoneNumber = null;
  }
}
