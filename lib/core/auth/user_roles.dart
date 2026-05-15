import '../../data/models/user_model.dart';

/// App roles returned by the API (`roles: ["EMPLOYEE"]`, etc.).
abstract final class UserRoles {
  static const employee = 'EMPLOYEE';
  static const manager = 'MANAGER';
  static const hrManager = 'HR_MANAGER';
  static const hrAdmin = 'HR_ADMIN';
  static const superAdmin = 'SUPER_ADMIN';

  static const _hrStaff = {superAdmin, hrAdmin, hrManager};

  static String? primary(UserModel? user) =>
      user?.roles.isNotEmpty == true ? user!.roles.first : null;

  static bool isEmployeeOnly(UserModel? user) {
    final role = primary(user);
    if (role == null) return true;
    return role == employee;
  }

  static bool canAccessHrAdmin(UserModel? user) {
    final role = primary(user);
    if (role == null) return false;
    return _hrStaff.contains(role) || role == manager;
  }

  static String label(String? role) {
    if (role == null || role.isEmpty) return '—';
    return role
        .toLowerCase()
        .split('_')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
