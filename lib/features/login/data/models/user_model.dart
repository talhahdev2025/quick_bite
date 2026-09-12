class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'student',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'role': role};
  }
}
