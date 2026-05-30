import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/services/post_store.dart';
import 'package:dental_case_matching_app/widgets/post_card.dart';
import 'package:dental_case_matching_app/widgets/patient_bottom_nav.dart';
import 'package:flutter/material.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = PostStore.posts;

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
              'View and manage the cases you have posted.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            if (posts.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'You have not created any posts yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
            else
              ...[
                for (final post in posts) ...[
                  PostCard(
                    title: post.title,
                    description: post.description,
                    caseType: post.suggestedCaseType,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
          ],
        ),
      ),
    );
  }
}
