import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/login/data/models/user_model.dart';
import 'package:quick_bite/features/login/data/repository/auth_repository.dart';
import 'package:quick_bite/features/login/data/repository/user_repository.dart';
import 'package:quick_bite/features/login/domain/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(auth: FirebaseAuth.instance),
);

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

final authStateStreamProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

//
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

//
class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _listenToAuthChanges();

    return AuthState(firebaseUser: _authRepository.currentUser);
  }

  void _listenToAuthChanges() {
    ref.listen<AsyncValue<User?>>(
      authStateStreamProvider,
      (previous, next) => next.whenData((firebaseUser) async {
        if (firebaseUser == null) {
          state = AuthState(firebaseUser: null, user: null, isLoading: false);
          return;
        }

        try {
          final appUser = await ref
              .read(userRepositoryProvider)
              .getUser(firebaseUser.uid);
          state = state.copyWith(
            firebaseUser: firebaseUser,
            user: appUser,
            isLoading: false,
          );
        } catch (e) {
          state = state.copyWith(
            firebaseUser: firebaseUser,
            isLoading: false,
            errorMessage: 'Failed to load user profile',
          );
        }

      }),
    );
  }

  //sign in
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('user now found');
      }

      final appUser = await ref
          .read(userRepositoryProvider)
          .getUser(firebaseUser.uid);
      if (appUser == null) {
        throw Exception('User document not found');
      }

      state = state.copyWith(
        isLoading: false,
        user: appUser,
        firebaseUser: firebaseUser,
      );
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Login failed',
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong',
      );
    }
  }
  //sign up

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final credential = await _authRepository.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception('User creation failed');
      }

      final user = UserModel(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        role: 'student',
      );
      await ref.read(userRepositoryProvider).createUser(user);

      state = state.copyWith(firebaseUser: firebaseUser, isLoading: false,user: user);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message ?? 'Signup failed',
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong',
      );
    }
  }

  //sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authRepository.signOut();
      state = AuthState(firebaseUser: null, isLoading: false,user: null);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to sign out',
      );
    }
  }
}
