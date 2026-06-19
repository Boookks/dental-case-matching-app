class UserModel {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.createdAt,
  });

  final String uid;
  final String name;
  final String email;
  final String role;
  final String? phoneNumber;
  final DateTime? createdAt;

  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    String? phoneNumber,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'patient',
      phoneNumber: map['phoneNumber'] as String?,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
    );
  }
}
