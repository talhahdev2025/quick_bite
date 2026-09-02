import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/features/login/data/auth_repository.dart';
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

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _listenToAuthChanges();

    return AuthState(user: _authRepository.currentUser);
  }

  void _listenToAuthChanges() {
    ref.listen<AsyncValue<User?>>(
      authStateStreamProvider,
      (previous, next) => next.whenData(
        (user) => state = state.copyWith(user: user, isLoading: false),
      ),
    );
  }

  //sign in
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
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
    required String name
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.createUserWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
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
      state =  AuthState(user: null, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to sign out',
      );
    }
  }
}
