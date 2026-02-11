import 'user_role.dart';

class User {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final UserRole role;

  const User({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.role,
  });
}

