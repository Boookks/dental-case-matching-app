import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/widgets/post_card.dart';
import 'package:dental_case_matching_app/widgets/patient_bottom_nav.dart';
import 'package:flutter/material.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
      ),
      bottomNavigationBar: PatientBottomNav(
        selectedIndex: 0,
        onHomeTap: () {
          Navigator.pushReplacementNamed(context, AppRoutes.patientHome);
        },
        onCreateTap: () {
          Navigator.pushNamed(context, AppRoutes.createPost);
        },
        onProfileTap: () {
          Navigator.pushNamed(context, AppRoutes.patientProfile);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Text(
              'My Posts',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your saved case posts from one place.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            const PostCard(
              title: 'Upper tooth pain',
              description:
                  'Pain while eating cold food and sensitivity near the molar.',
              caseType: 'Possible Cavity Case',
            ),
            const SizedBox(height: 12),
            const PostCard(
              title: 'Bleeding gums',
              description: 'Gums bleed during brushing and feel swollen.',
              caseType: 'Possible Gum Disease Case',
            ),
          ],
        ),
      ),
    );
  }
}
