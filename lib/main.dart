import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/constants/app_theme.dart';
import 'package:dental_case_matching_app/screens/auth/login_screen.dart';
import 'package:dental_case_matching_app/screens/auth/patient_contact_info_screen.dart';
import 'package:dental_case_matching_app/screens/auth/register_screen.dart';
import 'package:dental_case_matching_app/screens/auth/choose_account_type_screen.dart';
import 'package:dental_case_matching_app/screens/patient/create_post_screen.dart';
import 'package:dental_case_matching_app/screens/patient/my_posts_screen.dart';
import 'package:dental_case_matching_app/screens/patient/patient_home_screen.dart';
import 'package:dental_case_matching_app/screens/patient/profile_screen.dart'
    as patient_profile;
import 'package:dental_case_matching_app/screens/patient/smart_suggestion_screen.dart';
import 'package:dental_case_matching_app/screens/student/case_details_screen.dart';
import 'package:dental_case_matching_app/screens/student/profile_screen.dart'
    as student_profile;
import 'package:dental_case_matching_app/screens/student/student_home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DentalCaseMatchingApp());
}

class DentalCaseMatchingApp extends StatelessWidget {
  const DentalCaseMatchingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppTheme.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.chooseAccountType: (_) => const ChooseAccountTypeScreen(),
        AppRoutes.patientContactInfo: (_) => const PatientContactInfoScreen(),
        AppRoutes.patientHome: (_) => const PatientHomeScreen(),
        AppRoutes.smartSuggestion: (_) => const SmartSuggestionScreen(),
        AppRoutes.createPost: (_) => const CreatePostScreen(),
        AppRoutes.myPosts: (_) => const MyPostsScreen(),
        AppRoutes.patientProfile: (_) => const patient_profile.ProfileScreen(),
        AppRoutes.studentHome: (_) => const StudentHomeScreen(),
        AppRoutes.caseDetails: (_) => const CaseDetailsScreen(),
        AppRoutes.studentProfile: (_) => const student_profile.ProfileScreen(),
      },
    );
  }
}
