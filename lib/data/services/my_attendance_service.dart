import 'package:dio/dio.dart';

import '../../core/constants/app_endpoints.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_errors.dart';
import '../models/attendance_log_model.dart';

/// `/api/v1/my/attendance` — check-in / check-out punches (Zoho People–style).
class MyAttendanceService {
  Future<List<AttendanceLogModel>> fetchMyLogs() async {
    try {
      final res = await ApiClient.dio.get<List<dynamic>>(AppEndpoints.myAttendance);
      if (res.statusCode != 200 || res.data == null) return [];
      return res.data!
          .whereType<Map>()
          .map((e) => AttendanceLogModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    }
  }

  Future<AttendanceLogModel> checkIn() async {
    try {
      await ApiClient.ensureCsrfToken();
      final res = await ApiClient.dio.post<Map<String, dynamic>>(AppEndpoints.myAttendanceCheckIn);
      if (res.statusCode != 200 || res.data == null) {
        // The dashboard card catches ApiException to show a friendly snackbar; a bare Exception
        // here would slip past that handler and surface as an unhandled async error.
        throw ApiException('Check-in failed', res.statusCode);
      }
      return AttendanceLogModel.fromJson(res.data!);
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    }
  }

  Future<AttendanceLogModel> checkOut() async {
    try {
      await ApiClient.ensureCsrfToken();
      final res = await ApiClient.dio.post<Map<String, dynamic>>(AppEndpoints.myAttendanceCheckOut);
      if (res.statusCode != 200 || res.data == null) {
        throw ApiException('Check-out failed', res.statusCode);
      }
      return AttendanceLogModel.fromJson(res.data!);
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    }
  }
}
