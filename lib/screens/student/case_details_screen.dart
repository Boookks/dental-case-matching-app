import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/constants/app_strings.dart';
import 'package:dental_case_matching_app/models/post_model.dart';
import 'package:dental_case_matching_app/services/post_store.dart';
import 'package:dental_case_matching_app/widgets/student_bottom_nav.dart';
import 'package:flutter/material.dart';

class CaseDetailsScreen extends StatelessWidget {
  const CaseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fallbackPost = PostModel(
      postId: 'fallback',
      userId: 'demo-patient',
      title: 'Patient Case',
      description: 'No case details are available yet.',
      symptoms: const [],
      suggestedCaseType: 'Possible Cavity Case',
      contactInfo: 'Not provided',
      createdAt: DateTime.now(),
    );
    final post =
        ModalRoute.of(context)?.settings.arguments as PostModel? ??
            (PostStore.posts.isNotEmpty ? PostStore.posts.first : fallbackPost);
    final contactInfo = post.contactInfo.isEmpty
        ? 'Not provided'
        : post.contactInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      bottomNavigationBar: StudentBottomNav(
        selectedIndex: 0,
        onHomeTap: () {
          Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
        },
        onProfileTap: () {
          Navigator.pushReplacementNamed(context, AppRoutes.studentProfile);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Text(
              'Case Details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            _SummaryCard(
              title: post.suggestedCaseType,
              subtitle: post.title,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Contact Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Phone: $contactInfo',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.softBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.medical_information_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
