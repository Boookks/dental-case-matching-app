import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/models/post_model.dart';
import 'package:dental_case_matching_app/services/firestore_service.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
import 'package:dental_case_matching_app/widgets/patient_bottom_nav.dart';
import 'package:flutter/material.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final _firestoreService = FirestoreService();
  final Set<String> _expandedPostIds = <String>{};
  late final Stream<List<PostModel>> _postsStream;

  @override
  void initState() {
    super.initState();
    final userId = AppSession.currentUser?.uid;
    _postsStream = userId == null
        ? Stream<List<PostModel>>.value(const [])
        : _firestoreService.watchPostsForUser(userId);
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

  Future<bool> _confirmAction({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _closePost(PostModel post) async {
    final confirmed = await _confirmAction(
      title: 'Close Post?',
      message: 'This will move the post to Closed and hide it from students.',
      confirmLabel: 'Close',
    );

    if (!confirmed) {
      return;
    }

    try {
      await _firestoreService.closePost(post.postId);
      if (mounted) setState(() => _expandedPostIds.remove(post.postId));
    } catch (_) {
      _showMessage('Could not close the post. Please try again.');
    }
  }

  Future<void> _deletePost(PostModel post) async {
    final confirmed = await _confirmAction(
      title: 'Delete Post?',
      message:
          'This will permanently delete the post and remove it from student view.',
      confirmLabel: 'Delete',
    );

    if (!confirmed) {
      return;
    }

    try {
      await _firestoreService.deletePost(post.postId);
      if (mounted) setState(() => _expandedPostIds.remove(post.postId));
    } catch (_) {
      _showMessage('Could not delete the post. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateHome() {
    Navigator.pushReplacementNamed(context, AppRoutes.patientHome);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('My Posts')),
        bottomNavigationBar: PatientBottomNav(
          selectedIndex: 0,
          onHomeTap: _navigateHome,
          onCreateTap: () {
            Navigator.pushNamed(context, AppRoutes.createPost);
          },
          onProfileTap: () {
            Navigator.pushNamed(context, AppRoutes.patientProfile);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View, close, and delete the cases you have posted.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: AppColors.softBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        tabs: const [
                          Tab(text: 'Active'),
                          Tab(text: 'Closed'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<PostModel>>(
                  stream: _postsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const _PostsMessage(
                        message: 'Could not load your posts.',
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final activePosts = snapshot.data!
                        .where((post) => !post.isClosed)
                        .toList();
                    final closedPosts =
                        snapshot.data!.where((post) => post.isClosed).toList()
                          ..sort((first, second) {
                            final firstDate = first.closedAt ?? first.createdAt;
                            final secondDate =
                                second.closedAt ?? second.createdAt;
                            return (secondDate ?? DateTime(1970)).compareTo(
                              firstDate ?? DateTime(1970),
                            );
                          });

                    return TabBarView(
                      children: [
                        _PostsTab(
                          posts: activePosts,
                          emptyText: 'You have no active posts.',
                          emptySubtext:
                              'Create a new post or start a smart case suggestion.',
                          isClosedTab: false,
                          isExpanded: _isExpanded,
                          formatDate: _formatDate,
                          onToggleExpanded: _toggleExpanded,
                          onClose: _closePost,
                          onDelete: _deletePost,
                        ),
                        _PostsTab(
                          posts: closedPosts,
                          emptyText: 'You have no closed posts yet.',
                          emptySubtext:
                              'Posts you close will appear here for later review.',
                          isClosedTab: true,
                          isExpanded: _isExpanded,
                          formatDate: _formatDate,
                          onToggleExpanded: _toggleExpanded,
                          onClose: null,
                          onDelete: _deletePost,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostsMessage extends StatelessWidget {
  const _PostsMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

class _PostsTab extends StatelessWidget {
  const _PostsTab({
    required this.posts,
    required this.emptyText,
    required this.emptySubtext,
    required this.isClosedTab,
    required this.isExpanded,
    required this.formatDate,
    required this.onToggleExpanded,
    required this.onDelete,
    this.onClose,
  });

  final List<PostModel> posts;
  final String emptyText;
  final String emptySubtext;
  final bool isClosedTab;
  final bool Function(String postId) isExpanded;
  final String Function(DateTime? dateTime) formatDate;
  final void Function(String postId) onToggleExpanded;
  final Future<void> Function(PostModel post) onDelete;
  final Future<void> Function(PostModel post)? onClose;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emptyText,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    emptySubtext,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: posts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final post = posts[index];

        return _ManagedPostCard(
          post: post,
          isClosedTab: isClosedTab,
          expanded: isExpanded(post.postId),
          formatDate: formatDate,
          onToggleExpanded: () => onToggleExpanded(post.postId),
          onClose: onClose == null ? null : () => onClose!(post),
          onDelete: () => onDelete(post),
        );
      },
    );
  }
}

class _ManagedPostCard extends StatelessWidget {
  const _ManagedPostCard({
    required this.post,
    required this.isClosedTab,
    required this.expanded,
    required this.formatDate,
    required this.onToggleExpanded,
    required this.onDelete,
    this.onClose,
  });

  final PostModel post;
  final bool isClosedTab;
  final bool expanded;
  final String Function(DateTime? dateTime) formatDate;
  final VoidCallback onToggleExpanded;
  final VoidCallback onDelete;
  final VoidCallback? onClose;

  bool get _hasReadMore {
    return post.description.trim().length > 120;
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = isClosedTab ? 'Closed on' : 'Created on';
    final dateValue = isClosedTab ? post.closedAt : post.createdAt;

    return Card(
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
            const SizedBox(height: 12),
            Text(
              'Additional Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              post.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: expanded ? null : 3,
              overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (_hasReadMore) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onToggleExpanded,
                child: Text(expanded ? 'Show Less' : 'Read More'),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '$dateLabel: ${formatDate(dateValue)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (!isClosedTab) ...[
                  Expanded(
                    child: FilledButton(
                      onPressed: onClose,
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
