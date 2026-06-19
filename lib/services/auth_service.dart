import 'package:dental_case_matching_app/models/user_model.dart';
import 'package:dental_case_matching_app/services/firestore_service.dart';
import 'package:dental_case_matching_app/utils/account_type.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  factory AuthService({
    FirebaseAuth? auth,
    FirestoreService? firestoreService,
  }) {
    return AuthService._(auth, firestoreService ?? FirestoreService());
  }

  AuthService._(this._auth, this._firestoreService);

  final FirebaseAuth? _auth;
  final FirestoreService _firestoreService;

  FirebaseAuth get _firebaseAuth => _auth ?? FirebaseAuth.instance;

  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthFailure('Unable to log in. Please try again.');
      }

      final profile = await _firestoreService.getUser(user.uid);
      if (profile == null) {
        await _firebaseAuth.signOut();
        throw const AuthFailure('Your account profile could not be found.');
      }
      return profile;
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_messageForCode(error.code));
    } on AuthFailure {
      rethrow;
    } catch (_) {
      await _firebaseAuth.signOut();
      throw const AuthFailure(
        'Could not load your account. Check your connection and try again.',
      );
    }
  }

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required AccountType accountType,
    String? phoneNumber,
  }) async {
    User? createdUser;
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createdUser = credential.user;
      if (createdUser == null) {
        throw const AuthFailure('Unable to create your account.');
      }

      await createdUser.updateDisplayName(name);
      final profile = UserModel(
        uid: createdUser.uid,
        name: name,
        email: email,
        role: accountType.storageValue,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );
      await _firestoreService.saveUser(profile);
      return profile;
    } on FirebaseAuthException catch (error) {
      await _deleteCreatedUser(createdUser);
      throw AuthFailure(_messageForCode(error.code));
    } catch (error) {
      await _deleteCreatedUser(createdUser);
      if (error is AuthFailure) rethrow;
      throw const AuthFailure(
        'Account setup could not be completed. Please try again.',
      );
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> _deleteCreatedUser(User? user) async {
    if (user == null) return;
    try {
      await user.delete();
    } on FirebaseAuthException {
      // The original registration error is more useful to the user.
    }
  }

  static String _messageForCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'weak-password':
        return 'Use a password with at least 6 characters.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'operation-not-allowed':
        return 'Email and password login is not enabled yet.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;
}
