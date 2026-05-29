import 'package:dental_case_matching_app/models/post_model.dart';
import 'package:dental_case_matching_app/models/user_model.dart';

class FirestoreService {
  const FirestoreService();

  Future<void> saveUser(UserModel user) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  Future<void> savePost(PostModel post) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
}
