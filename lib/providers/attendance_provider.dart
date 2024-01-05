





import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/crud_state.dart';
import '../services/attendance_service.dart';

final attendanceProvider = StateNotifierProvider<AttendanceProvider, CrudState>((ref) => AttendanceProvider(CrudState.empty()));



class AttendanceProvider extends StateNotifier<CrudState>{
  AttendanceProvider(super.state);

  Future<void> addAttendance({
    int? id,
    required String token,
    required int student,
    required String status,
    required String date,

  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await AttendanceService(token,id??0).addAttendance(
        student: student,
        status: status,
        date: date
    );
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);

    });
  }

}

