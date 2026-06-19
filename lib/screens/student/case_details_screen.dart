import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/constants/app_strings.dart';
import 'package:dental_case_matching_app/models/post_model.dart';
import 'package:dental_case_matching_app/widgets/student_bottom_nav.dart';
import 'package:flutter/material.dart';

class CaseDetailsScreen extends StatefulWidget {
  const CaseDetailsScreen({super.key});

  @override
  State<CaseDetailsScreen> createState() => _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends State<CaseDetailsScreen> {
  final Set<String> _expandedPostIds = <String>{};

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Unknown date';
    }

    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = months[dateTime.month - 1];
    return '$month ${dateTime.day}, ${dateTime.year}';
  }

  bool _isExpanded(String postId) => _expandedPostIds.contains(postId);

  void _toggleExpanded(String postId) {
    setState(() {
      if (_expandedPostIds.contains(postId)) {
        _expandedPostIds.remove(postId);
      } else {
        _expandedPostIds.add(postId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fallbackPost = PostModel(
      postId: 'fallback',
      userId: '',
      patientName: 'Patient',
      title: 'Patient Case',
      description: 'No case details are available yet.',
      symptoms: const [],
      suggestedCaseType: 'Possible Cavity Case',
      isAlreadyAssessed: false,
      contactInfo: 'Not provided',
      createdAt: DateTime.now(),
    );
    final post =
        ModalRoute.of(context)?.settings.arguments as PostModel? ??
        fallbackPost;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.suggestedCaseType,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.softBlue,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  post.isAlreadyAssessed
                                      ? 'Already Assessed'
                                      : 'Not Yet Assessed',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Additional Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: _isExpanded(post.postId) ? null : 3,
                      overflow: _isExpanded(post.postId)
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    if (post.description.trim().length > 120) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _toggleExpanded(post.postId),
                        child: Text(
                          _isExpanded(post.postId) ? 'Show Less' : 'Read More',
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _InfoCard(
                      title: 'Patient Name',
                      child: Text(
                        post.patientName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      title: 'Contact Information',
                      child: Text(
                        post.contactInfo.isEmpty
                            ? 'Not provided'
                            : post.contactInfo,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      title: 'Posted on',
                      child: Text(
                        _formatDate(post.createdAt),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
