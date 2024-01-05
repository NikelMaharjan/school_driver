



import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../model/attendance_model.dart';
import '../providers/auth_provider.dart';


final studentAttendanceInfo = FutureProvider.family<List<AttendanceModel>, int>((ref, id) async {
  final token = ref.watch(authProvider);
  final studentAttendance = AttendanceService(token.user.token, id);
  return await studentAttendance.getAttendanceInfo();
});




class AttendanceService {
  String token;
  int id;

  AttendanceService(this.token,this.id);

  final dio = Dio();


  Future<List<AttendanceModel>> getAttendanceInfo() async {
    try {
      final response = await dio.get('${Api.studentBusAttendanceInfoUrl}$id',
          options: Options(headers: {HttpHeaders.authorizationHeader: 'token $token'}));



      if(response.statusCode == 204){
        throw "Nothing at the Moment";
      }
      final data = (response.data['navigation']['data'] as List)
          .map((e) => AttendanceModel.fromJson(e))
          .toList();



      return data;
    } on DioException catch (err) {
      print(err.response);
      throw Exception('Unable to fetch data');
    }
  }

  Future<Either<String, dynamic>> addAttendance({
    required int student,
    required String status,
    required String date
  }) async {


    print("DATE IS $date");

    try {
      final response = await dio.post(Api.studentBusAttendanceUrl,
          data: {
            'student': student,
            'status': status,
            'attended_date': date
          },
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $token'}));
      return Right(response.data);
    } on DioException catch (err) {


      return Left(err.response!.data['data'].toString());
    }
  }
}
