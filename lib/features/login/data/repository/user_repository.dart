import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/features/login/data/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({required this._firestore});

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists) {
      return null;
    }
    return UserModel.fromMap(snapshot.id, snapshot.data()!);
  }
}
