import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/services/auth_service.dart';
import 'package:dental_case_matching_app/utils/account_type.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
import 'package:dental_case_matching_app/utils/jordanian_phone.dart';
import 'package:dental_case_matching_app/widgets/app_page_scaffold.dart';
import 'package:dental_case_matching_app/widgets/custom_button.dart';
import 'package:dental_case_matching_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class PatientContactInfoScreen extends StatefulWidget {
  const PatientContactInfoScreen({super.key});

  @override
  State<PatientContactInfoScreen> createState() =>
      _PatientContactInfoScreenState();
}

class _PatientContactInfoScreenState extends State<PatientContactInfoScreen> {
  late final TextEditingController _phoneController;
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: AppSession.patientPhoneNumber ?? '',
    );
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _isValid {
    final normalized = normalizeJordanianPhone(_phoneController.text);
    return isValidJordanianPhone(normalized);
  }

  Future<void> _savePhoneNumber() async {
    final normalizedPhone = normalizeJordanianPhone(_phoneController.text);

    if (!isValidJordanianPhone(normalizedPhone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid Jordanian phone number like 07XXXXXXXX.',
          ),
        ),
      );
      return;
    }

    if (!AppSession.hasPendingRegistration) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your account details again.')),
      );
      Navigator.popUntil(context, ModalRoute.withName(AppRoutes.register));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await _authService.registerWithEmail(
        name: AppSession.pendingName!,
        email: AppSession.pendingEmail!,
        password: AppSession.pendingPassword!,
        accountType: AccountType.patient,
        phoneNumber: normalizedPhone,
      );
      AppSession.setCurrentUser(user);
      AppSession.clearPendingRegistration();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.patientHome,
        (route) => false,
      );
    } on AuthFailure catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Add Contact Number',
      subtitle:
          'Enter a valid Jordanian phone number to finish setting up your patient account.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'This number is required. It will be used for WhatsApp contact and future posts.',
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
            'Use a Jordanian number in 07XXXXXXXX format.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: _isLoading ? 'Creating Account...' : 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: _isValid && !_isLoading ? _savePhoneNumber : null,
          ),
        ],
      ),
    );
  }
}
