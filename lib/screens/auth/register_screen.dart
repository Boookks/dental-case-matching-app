import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
import 'package:dental_case_matching_app/widgets/app_page_scaffold.dart';
import 'package:dental_case_matching_app/widgets/custom_button.dart';
import 'package:dental_case_matching_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Create an account',
      subtitle: 'Fill in the details to create your account.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomTextField(
            label: 'Full name',
            hintText: 'Your name',
          ),
          const SizedBox(height: 12),
          const CustomTextField(
            label: 'Email',
            hintText: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          const CustomTextField(
            label: 'Password',
            hintText: 'Create a password',
            obscureText: true,
          ),
          const SizedBox(height: 12),
          const CustomTextField(
            label: 'Confirm password',
            hintText: 'Re-enter your password',
            obscureText: true,
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: 'Create Account',
            icon: Icons.person_add_alt_1_outlined,
            onPressed: () {
              AppSession.clearSession();
              Navigator.pushNamed(context, AppRoutes.chooseAccountType);
            },
          ),
        ],
      ),
    );
  }
}
