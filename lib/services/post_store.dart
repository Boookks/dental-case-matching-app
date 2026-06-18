import 'package:dental_case_matching_app/models/post_model.dart';

class PostStore {
  PostStore._();

  static const String demoPatientUserId = 'demo-patient';

  static final List<PostModel> _posts = <PostModel>[];

  static List<PostModel> get posts => allPosts;

  static List<PostModel> get allPosts => List.unmodifiable(_posts);

  static List<PostModel> get activePosts {
    final active = _posts.where((post) => !post.isClosed).toList();
    active.sort(_postComparator);
    return List.unmodifiable(active);
  }

  static List<PostModel> get closedPosts {
    final closed = _posts.where((post) => post.isClosed).toList();
    closed.sort(_closedPostComparator);
    return List.unmodifiable(closed);
  }

  static List<PostModel> postsForUser(String userId) {
    final userPosts = _posts.where((post) => post.userId == userId).toList();
    userPosts.sort(_postComparator);
    return List.unmodifiable(userPosts);
  }

  static List<PostModel> activePostsForUser(String userId) {
    final userPosts =
        _posts.where((post) => post.userId == userId && !post.isClosed).toList();
    userPosts.sort(_postComparator);
    return List.unmodifiable(userPosts);
  }

  static List<PostModel> closedPostsForUser(String userId) {
    final userPosts =
        _posts.where((post) => post.userId == userId && post.isClosed).toList();
    userPosts.sort(_closedPostComparator);
    return List.unmodifiable(userPosts);
  }

  static void addPost(PostModel post) {
    _posts.insert(0, post);
  }

  static void closePost(String postId) {
    final index = _posts.indexWhere((post) => post.postId == postId);
    if (index == -1) {
      return;
    }

    final post = _posts[index];
    if (post.isClosed) {
      return;
    }

    _posts[index] = post.copyWith(
      isClosed: true,
      closedAt: DateTime.now(),
    );
  }

  static void deletePost(String postId) {
    _posts.removeWhere((post) => post.postId == postId);
  }

  static int _postComparator(PostModel a, PostModel b) {
    final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bDate.compareTo(aDate);
  }

  static int _closedPostComparator(PostModel a, PostModel b) {
    final aDate =
        a.closedAt ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bDate =
        b.closedAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bDate.compareTo(aDate);
  }
}
