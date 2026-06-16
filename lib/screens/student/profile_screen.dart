import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/widgets/profile_identity_card.dart';
import 'package:dental_case_matching_app/widgets/student_bottom_nav.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.studentHome,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: StudentBottomNav(
          selectedIndex: 1,
          onHomeTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
          },
          onProfileTap: () {},
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            children: [
              const ProfileIdentityCard(
                title: 'Student Profile',
                description:
                    'View your account information and sign out when you are done browsing cases.',
                name: 'Demo Student',
                email: 'student@example.com',
                role: 'Dental Student',
                avatarIcon: Icons.school_rounded,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Logout from this device when you are done browsing cases.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Color(0xFFFFCDD2)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
