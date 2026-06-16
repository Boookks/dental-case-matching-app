import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/constants/app_strings.dart';
import 'package:dental_case_matching_app/services/post_store.dart';
import 'package:dental_case_matching_app/widgets/post_card.dart';
import 'package:dental_case_matching_app/widgets/student_bottom_nav.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = PostStore.posts;

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
              'Filtered Cases',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Quickly narrow down the case list by issue type.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'All', selected: true),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Cavity'),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Gum Disease'),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Root Canal'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (posts.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'No cases match the current filters yet.',
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
                    statusLabel:
                        post.isAlreadyAssessed ? 'Already Assessed' : 'Not Yet Assessed',
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.caseDetails,
                      arguments: post,
                    ),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.selected = false,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.softBlue : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
      ),
    );
  }
}
