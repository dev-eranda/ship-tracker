// core/providers/dev_users.dart
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

  static const guest = User(
    id: 'u_guest_1',
    name: 'Guest',
    role: UserRole.guest,
  );

  static const all = [admin, regular, guest];
}
