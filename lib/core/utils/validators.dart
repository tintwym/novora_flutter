String? emailValidator(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  if (!v.contains('@')) return 'Enter a valid email';
  return null;
}

String? passwordValidator(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  if (v.length < 6) return 'At least 6 characters';
  return null;
}

/// Matches Spring `AuthDtos.PASSWORD_PATTERN` (BCrypt-friendly).
String? strongPasswordValidator(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  final re = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,72}$',
  );
  if (!re.hasMatch(v)) {
    return '8–72 chars with upper, lower, number, and symbol';
  }
  return null;
}

String? requiredValidator(String? v, [String field = 'This field']) {
  if (v == null || v.trim().isEmpty) return '$field is required';
  return null;
}
