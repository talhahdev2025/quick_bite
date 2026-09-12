import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bite/features/login/data/models/user_model.dart';

class AuthState {
  User? firebaseUser;
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.firebaseUser,
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isLoggedIn => firebaseUser != null;

  AuthState copyWith({
    User? firebaseUser,
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
