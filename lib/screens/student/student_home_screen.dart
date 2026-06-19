import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/constants/app_strings.dart';
import 'package:dental_case_matching_app/models/post_model.dart';
import 'package:dental_case_matching_app/services/firestore_service.dart';
import 'package:dental_case_matching_app/widgets/post_card.dart';
import 'package:dental_case_matching_app/widgets/student_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  static const List<String> _filterLabels = <String>[
    'All',
    'Cavity',
    'Gum Disease',
    'Root Canal',
    'Extraction',
    'Prosthesis',
    'Braces',
  ];

  String _selectedFilter = 'All';
  final _postsStream = FirestoreService().watchActivePosts();

  List<PostModel> _filteredPosts(List<PostModel> posts) {
    if (_selectedFilter == 'All') {
      return posts;
    }

    return posts.where((post) {
      return _normalizedCaseType(post.suggestedCaseType) ==
          _selectedFilter.toLowerCase();
    }).toList();
  }

  String _normalizedCaseType(String caseType) {
    final cleaned = caseType
        .replaceAll(RegExp(r'^possible\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+case$', caseSensitive: false), '')
        .trim();

    return cleaned.toLowerCase();
  }

  void _setFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
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
          child: StreamBuilder<List<PostModel>>(
            stream: _postsStream,
            builder: (context, snapshot) {
              final posts = _filteredPosts(snapshot.data ?? const []);

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                children: [
                  Text(
                    'All Cases',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use the case chips to narrow down the list.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final label in _filterLabels) ...[
                          _CaseFilterChip(
                            label: label,
                            selected: _selectedFilter == label,
                            onTap: () => _setFilter(label),
                          ),
                          if (label != _filterLabels.last)
                            const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (snapshot.hasError)
                    _FeedMessage(message: 'Could not load patient cases.')
                  else if (!snapshot.hasData)
                    const Center(child: CircularProgressIndicator())
                  else if (posts.isEmpty)
                    _FeedMessage(
                      message: _selectedFilter == 'All'
                          ? 'No cases are available yet.'
                          : 'No cases match this filter yet.',
                    )
                  else ...[
                    for (final post in posts) ...[
                      PostCard(
                        title: post.suggestedCaseType,
                        description: post.description,
                        assessmentLabel: post.isAlreadyAssessed
                            ? 'Already Assessed'
                            : 'Not Yet Assessed',
                        dateLabel: 'Posted on',
                        dateValue: _formatDate(post.createdAt),
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
              );
            },
          ),
        ),
      ),
    );
  }

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
}

class _FeedMessage extends StatelessWidget {
  const _FeedMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

class _CaseFilterChip extends StatelessWidget {
  const _CaseFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
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
        ),
      ),
    );
  }
}
