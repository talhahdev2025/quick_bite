import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository({required this._auth});

  //sign in
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //sign up
  Future<UserCredential> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // await userCredential.user?.updateDisplayName(name);
    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();
    }
    return userCredential;
  }

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.userChanges();

  User? get currentUser => _auth.currentUser;
}
