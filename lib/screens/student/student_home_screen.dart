import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/constants/app_strings.dart';
import 'package:dental_case_matching_app/services/post_store.dart';
import 'package:dental_case_matching_app/widgets/post_card.dart';
import 'package:dental_case_matching_app/widgets/student_bottom_nav.dart';
import 'package:flutter/material.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = PostStore.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: StudentBottomNav(
        selectedIndex: 0,
        onHomeTap: () {},
        onProfileTap: () {
          Navigator.pushReplacementNamed(context, AppRoutes.studentProfile);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search_rounded),
                        hintText: 'Search cases',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.filterCases);
                    },
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'All Cases',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            if (posts.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'No cases are available yet.',
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
