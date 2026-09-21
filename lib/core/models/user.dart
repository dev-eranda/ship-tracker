enum UserRole { admin, user }

class User {
  final int id;
  final String name;
  final UserRole role;

  const User({required this.id, required this.name, this.role = UserRole.user});

  bool get isAdmin => role == UserRole.admin;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: (json['name'] ?? json['username'] ?? '') as String,
    role: _parseRole(json['role']),
  );

  static UserRole _parseRole(dynamic value) {
    switch (value.toString().toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }
}
