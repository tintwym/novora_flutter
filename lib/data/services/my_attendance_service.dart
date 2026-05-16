import 'package:dio/dio.dart';

import '../../core/constants/app_endpoints.dart';
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
    await ApiClient.ensureCsrfToken();
    try {
      final res = await ApiClient.dio.post<Map<String, dynamic>>(AppEndpoints.myAttendanceCheckIn);
      if (res.statusCode != 200 || res.data == null) {
        throw Exception('Check-in failed');
      }
      return AttendanceLogModel.fromJson(res.data!);
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    }
  }

  Future<AttendanceLogModel> checkOut() async {
    await ApiClient.ensureCsrfToken();
    try {
      final res = await ApiClient.dio.post<Map<String, dynamic>>(AppEndpoints.myAttendanceCheckOut);
      if (res.statusCode != 200 || res.data == null) {
        throw Exception('Check-out failed');
      }
      return AttendanceLogModel.fromJson(res.data!);
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    }
  }
}
