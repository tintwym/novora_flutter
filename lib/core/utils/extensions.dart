extension StringX on String {
  String get trimmedOrEmpty => trim();
}

extension ListX<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
