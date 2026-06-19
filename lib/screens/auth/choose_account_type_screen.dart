import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/services/auth_service.dart';
import 'package:dental_case_matching_app/utils/account_type.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
import 'package:dental_case_matching_app/widgets/app_page_scaffold.dart';
import 'package:flutter/material.dart';

class ChooseAccountTypeScreen extends StatefulWidget {
  const ChooseAccountTypeScreen({super.key});

  @override
  State<ChooseAccountTypeScreen> createState() =>
      _ChooseAccountTypeScreenState();
}

class _ChooseAccountTypeScreenState extends State<ChooseAccountTypeScreen> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _registerStudent() async {
    if (!AppSession.hasPendingRegistration) {
      _showMessage('Enter your account details again.');
      Navigator.pop(context);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await _authService.registerWithEmail(
        name: AppSession.pendingName!,
        email: AppSession.pendingEmail!,
        password: AppSession.pendingPassword!,
        accountType: AccountType.dentalStudent,
      );
      AppSession.setCurrentUser(user);
      AppSession.clearPendingRegistration();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.studentHome,
        (route) => false,
      );
    } on AuthFailure catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _choosePatient() {
    if (!AppSession.hasPendingRegistration) {
      _showMessage('Enter your account details again.');
      Navigator.pop(context);
      return;
    }
    AppSession.setAccountType(AccountType.patient);
    Navigator.pushNamed(context, AppRoutes.patientContactInfo);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
            onTap: _isLoading ? null : _registerStudent,
          ),
          const SizedBox(height: 16),
          _AccountTypeCard(
            title: 'Patient',
            description: 'Create posts for dental issues',
            icon: Icons.person_outline,
            onTap: _isLoading ? null : _choosePatient,
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
  final VoidCallback? onTap;

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
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
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
