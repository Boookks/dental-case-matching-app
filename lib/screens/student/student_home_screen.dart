import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_strings.dart';
import 'package:dental_case_matching_app/widgets/post_card.dart';
import 'package:dental_case_matching_app/widgets/student_bottom_nav.dart';
import 'package:flutter/material.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
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
            PostCard(
              title: 'Upper molar pain',
              description:
                  'Patient reports sensitivity when eating cold food and pressure on the upper right molar.',
              caseType: 'Possible Cavity Case',
              onTap: () => Navigator.pushNamed(context, AppRoutes.caseDetails),
            ),
            const SizedBox(height: 12),
            PostCard(
              title: 'Bleeding gums',
              description:
                  'Gums bleed during brushing and feel swollen near the front teeth.',
              caseType: 'Possible Gum Disease Case',
              onTap: () => Navigator.pushNamed(context, AppRoutes.caseDetails),
            ),
            const SizedBox(height: 12),
            PostCard(
              title: 'Jaw pain after eating',
              description:
                  'Pain starts when chewing hard food and the patient feels discomfort in the back lower jaw.',
              caseType: 'Possible Root Canal Case',
              onTap: () => Navigator.pushNamed(context, AppRoutes.caseDetails),
            ),
          ],
        ),
      ),
    );
  }
}
