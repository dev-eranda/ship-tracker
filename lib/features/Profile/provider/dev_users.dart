import 'package:ship_tracker/core/models/user.dart';

class DevUsers {
  static const admin = User(id: 12, name: 'Alice Admin', role: UserRole.admin);

  static const regular = User(id: 32, name: 'Bob Fisher', role: UserRole.user);

  static const all = [admin, regular];
}
