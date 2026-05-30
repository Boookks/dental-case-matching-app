import 'package:dental_case_matching_app/models/post_model.dart';

class PostStore {
  PostStore._();

  static final List<PostModel> _posts = <PostModel>[
    PostModel(
      postId: 'demo-1',
      userId: 'demo-patient',
      title: 'Upper molar pain',
      description:
          'Pain while eating cold food and sensitivity near the upper right molar.',
      symptoms: const [],
      suggestedCaseType: 'Possible Cavity Case',
      contactInfo: '0790000000',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PostModel(
      postId: 'demo-2',
      userId: 'demo-patient',
      title: 'Bleeding gums',
      description: 'Gums bleed during brushing and feel swollen.',
      symptoms: const [],
      suggestedCaseType: 'Possible Gum Disease Case',
      contactInfo: '0790000000',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PostModel(
      postId: 'demo-3',
      userId: 'demo-patient',
      title: 'Jaw pain after eating',
      description:
          'Pain starts when chewing hard food and the patient feels discomfort in the back lower jaw.',
      symptoms: const [],
      suggestedCaseType: 'Possible Root Canal Case',
      contactInfo: '0790000000',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static List<PostModel> get posts => List.unmodifiable(_posts);

  static void addPost(PostModel post) {
    _posts.insert(0, post);
  }
}
