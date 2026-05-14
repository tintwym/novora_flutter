/// Generic API envelope (extend when backend contract stabilizes).
class ApiResponse<T> {
  const ApiResponse({this.data, this.error, this.statusCode});

  final T? data;
  final String? error;
  final int? statusCode;

  bool get isSuccess => error == null && statusCode != null && statusCode! < 400;
}
