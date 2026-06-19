import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/services/auth_service.dart';
import 'package:dental_case_matching_app/services/firestore_service.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
import 'package:dental_case_matching_app/utils/jordanian_phone.dart';
import 'package:dental_case_matching_app/widgets/custom_button.dart';
import 'package:dental_case_matching_app/widgets/custom_textfield.dart';
import 'package:dental_case_matching_app/widgets/patient_bottom_nav.dart';
import 'package:dental_case_matching_app/widgets/profile_identity_card.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _phoneController;
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  bool _isSavingPhone = false;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: AppSession.patientPhoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _savePhoneNumber() async {
    final normalizedPhone = normalizeJordanianPhone(_phoneController.text);
    final currentSavedPhone = AppSession.patientPhoneNumber ?? '';

    if (!isValidJordanianPhone(normalizedPhone)) {
      _phoneController.text = currentSavedPhone;
      _phoneController.selection = TextSelection.collapsed(
        offset: currentSavedPhone.length,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid Jordanian phone number like 07XXXXXXXX.',
          ),
        ),
      );
      return;
    }

    final user = AppSession.currentUser;
    if (user == null) {
      _showMessage('Please log in again to update your contact number.');
      return;
    }

    setState(() => _isSavingPhone = true);
    try {
      await _firestoreService.updatePatientPhone(user.uid, normalizedPhone);
      AppSession.setPatientPhoneNumber(normalizedPhone);
      if (!mounted) return;
      _phoneController.text = normalizedPhone;
      _phoneController.selection = TextSelection.collapsed(
        offset: normalizedPhone.length,
      );
      _showMessage('Contact number saved.');
    } catch (_) {
      _phoneController.text = currentSavedPhone;
      _showMessage('Could not save the contact number. Please try again.');
    } finally {
      if (mounted) setState(() => _isSavingPhone = false);
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    try {
      await _authService.signOut();
      AppSession.clearSession();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } catch (_) {
      _showMessage('Could not log out. Please try again.');
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.patientHome,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: PatientBottomNav(
          selectedIndex: 1,
          onHomeTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.patientHome);
          },
          onCreateTap: () {
            Navigator.pushNamed(context, AppRoutes.createPost);
          },
          onProfileTap: () {},
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            children: [
              ProfileIdentityCard(
                title: 'Patient Profile',
                description:
                    'View your account information, update your required contact number, and sign out.',
                name: AppSession.currentUser?.name ?? 'Patient',
                email: AppSession.currentUser?.email ?? '',
                role: 'Patient',
                avatarIcon: Icons.person_rounded,
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
                      'Contact Info',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Jordanian phone number is required and will be used for WhatsApp and future posts.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Jordanian Phone Number',
                      hintText: '07XXXXXXXX',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Use a local Jordanian number in 07XXXXXXXX format.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      label: _isSavingPhone ? 'Saving...' : 'Save Contact Info',
                      icon: Icons.save_outlined,
                      onPressed: _isSavingPhone ? null : _savePhoneNumber,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Account', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Logout from this device when you finish using the app.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _isLoggingOut ? null : _logout,
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(_isLoggingOut ? 'Logging Out...' : 'Logout'),
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
