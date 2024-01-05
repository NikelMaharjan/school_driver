


import 'package:driver/model/bus_model.dart';

class AttendanceModel{
  final int id;
  final StudentBusRoute studentId;
  final String status;
  final String date;

  AttendanceModel({
    required this.status,
    required this.date,
    required this.studentId,
    required this.id
});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
        status: json['status'],
        date: json['attended_date'],
        studentId: StudentBusRoute.fromJson(json['student']),
        id: json['id']
    );
  }

}