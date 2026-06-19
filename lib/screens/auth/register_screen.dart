import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
import 'package:dental_case_matching_app/widgets/app_page_scaffold.dart';
import 'package:dental_case_matching_app/widgets/custom_button.dart';
import 'package:dental_case_matching_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _continueToAccountType() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    String? error;
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      error = 'Fill in all account details.';
    } else if (!email.contains('@') || !email.contains('.')) {
      error = 'Enter a valid email address.';
    } else if (password.length < 6) {
      error = 'Use a password with at least 6 characters.';
    } else if (password != confirmPassword) {
      error = 'The passwords do not match.';
    }

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    AppSession.clearSession();
    AppSession.setPendingRegistration(
      name: name,
      email: email,
      password: password,
    );
    Navigator.pushNamed(context, AppRoutes.chooseAccountType);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Create an account',
      subtitle: 'Fill in the details to create your account.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: 'Full name',
            hintText: 'Your name',
            controller: _nameController,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Email',
            hintText: 'you@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Password',
            hintText: 'Create a password',
            controller: _passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            label: 'Confirm password',
            hintText: 'Re-enter your password',
            controller: _confirmPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: 'Create Account',
            icon: Icons.person_add_alt_1_outlined,
            onPressed: _continueToAccountType,
          ),
        ],
      ),
    );
  }
}
