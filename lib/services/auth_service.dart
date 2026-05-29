class AuthService {
  const AuthService();

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
