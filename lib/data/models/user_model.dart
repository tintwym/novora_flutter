/// Authenticated user profile (maps from Spring `/api/v1/me` and auth responses).
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.roles = const [],
    this.accessToken,
    this.tokenType,
  });

  final String id;
  final String email;
  final String displayName;
  final List<String> roles;
  final String? accessToken;
  final String? tokenType;

  String? get primaryRole => roles.isEmpty ? null : roles.first;

  bool get isEmployee => primaryRole == 'EMPLOYEE';

  bool get canAccessHrAdmin =>
      const {'SUPER_ADMIN', 'HR_ADMIN', 'HR_MANAGER', 'MANAGER'}.contains(primaryRole);

  factory UserModel.fromAuthJson(Map<String, dynamic> json) {
    final rawId = json['userId'];
    final id = rawId == null ? '' : rawId.toString();
    final email = json['email'] as String? ?? '';
    final roles = (json['roles'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];
    final local = email.split('@').first;
    return UserModel(
      id: id,
      email: email,
      displayName: local.isNotEmpty ? local : email,
      roles: roles,
      accessToken: json['accessToken'] as String?,
      tokenType: json['tokenType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': id,
        'email': email,
        'roles': roles,
        'accessToken': accessToken,
        'tokenType': tokenType,
      };
}
