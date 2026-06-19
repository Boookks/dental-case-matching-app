import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/models/user_model.dart';
import 'package:dental_case_matching_app/utils/account_type.dart';

class AppSession {
  AppSession._();

  static AccountType? accountType;
  static String? patientPhoneNumber;
  static UserModel? currentUser;
  static String? pendingName;
  static String? pendingEmail;
  static String? pendingPassword;

  static bool get hasPendingRegistration =>
      pendingName != null && pendingEmail != null && pendingPassword != null;

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
    final user = currentUser;
    if (user != null) {
      currentUser = user.copyWith(phoneNumber: phoneNumber);
    }
  }

  static void setCurrentUser(UserModel user) {
    currentUser = user;
    accountType = accountTypeFromStorage(user.role);
    patientPhoneNumber = user.phoneNumber;
  }

  static void setPendingRegistration({
    required String name,
    required String email,
    required String password,
  }) {
    pendingName = name;
    pendingEmail = email;
    pendingPassword = password;
  }

  static void clearPendingRegistration() {
    pendingName = null;
    pendingEmail = null;
    pendingPassword = null;
  }

  static void clearAccountType() {
    accountType = null;
  }

  static void clearSession() {
    accountType = null;
    patientPhoneNumber = null;
    currentUser = null;
    clearPendingRegistration();
  }
}
