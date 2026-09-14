class User {
  final String id;
  final String name;
  final UserRole role;

  const User({required this.id, required this.name, required this.role});

  bool get isAdmin => role == UserRole.admin;
}

enum UserRole { admin, user }
