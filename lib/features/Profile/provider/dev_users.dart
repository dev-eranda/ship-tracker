import 'package:ship_tracker/core/models/user.dart';

class DevUsers {
  static const admin = User(
    id: 'u_admin_1',
    name: 'Alice Admin',
    role: UserRole.admin,
  );

  static const regular = User(
    id: 'u_user_1',
    name: 'Bob Fisher',
    role: UserRole.user,
  );

  static const all = [admin, regular];
}
