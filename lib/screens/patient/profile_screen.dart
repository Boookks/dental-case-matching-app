import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
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

  void _savePhoneNumber() {
    final normalizedPhone = _normalizeJordanianPhone(_phoneController.text);

    if (!_isValidJordanianPhone(normalizedPhone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid Jordanian phone number like 07XXXXXXXX.'),
        ),
      );
      return;
    }

    setState(() {
      _phoneController.text = normalizedPhone;
      _phoneController.selection = TextSelection.collapsed(
        offset: normalizedPhone.length,
      );
      AppSession.setPatientPhoneNumber(normalizedPhone);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact number saved.'),
      ),
    );
  }

  String _normalizeJordanianPhone(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9+]'), '');
    final cleaned = digitsOnly.startsWith('+')
        ? digitsOnly.substring(1)
        : digitsOnly;

    if (cleaned.startsWith('9627') && cleaned.length == 12) {
      return '0${cleaned.substring(3)}';
    }

    return cleaned;
  }

  bool _isValidJordanianPhone(String value) {
    return RegExp(r'^07\d{8}$').hasMatch(value);
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const ProfileIdentityCard(
              title: 'Patient Profile',
              description:
                  'View your account information, update your contact number, and sign out.',
              name: 'Demo Patient',
              email: 'patient@example.com',
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
                    'Add your Jordanian phone number so it can be used for WhatsApp and attached to future posts automatically.',
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
                    label: 'Save Contact Info',
                    icon: Icons.save_outlined,
                    onPressed: _savePhoneNumber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Account',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
                    onPressed: _logout,
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
    );
  }
}
