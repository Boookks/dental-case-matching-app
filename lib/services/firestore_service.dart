import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_case_matching_app/models/post_model.dart';
import 'package:dental_case_matching_app/models/user_model.dart';

class FirestoreService {
  factory FirestoreService({FirebaseFirestore? firestore}) {
    return FirestoreService._(firestore);
  }

  FirestoreService._(this._firestore);

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _database => _firestore ?? FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await _database.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _database.collection('users').doc(uid).get();
    final data = snapshot.data();
    return data == null ? null : UserModel.fromMap(data);
  }

  Future<void> updatePatientPhone(String uid, String phoneNumber) async {
    await _database.collection('users').doc(uid).update({
      'phoneNumber': phoneNumber,
    });
  }

  Future<void> savePost(PostModel post) async {
    await _database.collection('posts').doc(post.postId).set(post.toMap());
  }

  Stream<List<PostModel>> watchPostsForUser(String userId) {
    return _database
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final posts = snapshot.docs
              .map((document) => PostModel.fromMap(document.data()))
              .toList();
          posts.sort(_createdAtDescending);
          return posts;
        });
  }

  Stream<List<PostModel>> watchActivePosts() {
    return _database
        .collection('posts')
        .where('isClosed', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          final posts = snapshot.docs
              .map((document) => PostModel.fromMap(document.data()))
              .toList();
          posts.sort(_createdAtDescending);
          return posts;
        });
  }

  Future<void> closePost(String postId) async {
    await _database.collection('posts').doc(postId).update({
      'isClosed': true,
      'closedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deletePost(String postId) async {
    await _database.collection('posts').doc(postId).delete();
  }

  static int _createdAtDescending(PostModel first, PostModel second) {
    final firstDate = first.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final secondDate =
        second.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return secondDate.compareTo(firstDate);
  }
}
