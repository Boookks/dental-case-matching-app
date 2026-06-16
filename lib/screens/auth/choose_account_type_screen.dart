import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/utils/account_type.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
import 'package:dental_case_matching_app/widgets/app_page_scaffold.dart';
import 'package:flutter/material.dart';

class ChooseAccountTypeScreen extends StatelessWidget {
  const ChooseAccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Choose Account Type',
      subtitle: 'Select the account you want to use in this app.',
      child: Column(
        children: [
          _AccountTypeCard(
            title: 'Dental Student',
            description: 'Browse and contact patient cases',
            icon: Icons.school_outlined,
            onTap: () {
              AppSession.setAccountType(AccountType.dentalStudent);
              Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
            },
          ),
          const SizedBox(height: 16),
          _AccountTypeCard(
            title: 'Patient',
            description: 'Create posts for dental issues',
            icon: Icons.person_outline,
            onTap: () {
              AppSession.setAccountType(AccountType.patient);
              final hasPhoneNumber =
                  AppSession.patientPhoneNumber?.trim().isNotEmpty ?? false;
              if (hasPhoneNumber) {
                Navigator.pushReplacementNamed(context, AppRoutes.patientHome);
                return;
              }

              Navigator.pushNamed(context, AppRoutes.patientContactInfo);
            },
          ),
        ],
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  const _AccountTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
