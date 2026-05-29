import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/widgets/custom_button.dart';
import 'package:dental_case_matching_app/widgets/custom_textfield.dart';
import 'package:dental_case_matching_app/widgets/patient_bottom_nav.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      bottomNavigationBar: PatientBottomNav(
        selectedIndex: 0,
        onHomeTap: () {
          Navigator.pushReplacementNamed(context, AppRoutes.patientHome);
        },
        onCreateTap: () {},
        onProfileTap: () {
          Navigator.pushNamed(context, AppRoutes.patientProfile);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Text(
              'Create Post',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Title',
              hintText: 'Short case title',
            ),
            const SizedBox(height: 12),
            const CustomTextField(
              label: 'Symptoms',
              hintText: 'List the symptoms',
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            const CustomTextField(
              label: 'Contact Info',
              hintText: 'Phone, email, or WhatsApp',
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Save Draft',
              icon: Icons.save_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
