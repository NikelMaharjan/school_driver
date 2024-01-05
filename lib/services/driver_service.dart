




import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api.dart';
import '../model/bus_model.dart';
import '../providers/auth_provider.dart';


final busInfo = FutureProvider.family(
        (ref, String token) => BusService(token).getBusInfo());

final locationInfo = FutureProvider.family(
        (ref, String token) => BusLocationService(token).getLocationInfo());


final studentBusProvider = FutureProvider.family<List<StudentBusRoute>, int>((ref, id) async {
  final token = ref.watch(authProvider);
  final studentBus = StudentBusRouteService(token.user.token, id);
  return await studentBus.getStudentList();
});

class BusService {
  String token;

  BusService(this.token);

  final dio = Dio();

  Future<List<BusRouteAssignment>> getBusInfo() async {
    try {
      final response = await dio.get('${Api.busRouteAssignmentUrl}',
          options: Options(headers: {HttpHeaders.authorizationHeader: 'token $token'}));
      final data = (response.data['navigation']['data'] as List)
          .map((e) => BusRouteAssignment.fromJson(e))
          .toList();
      print('success');
      return data;
    } on DioError catch (err) {
      print(err.response);
      throw Exception('Unable to fetch data');
    }
  }
}





class StudentBusRouteService {
  String token;
  int id;

  StudentBusRouteService(this.token, this.id);

  final dio = Dio();

  Future<List<StudentBusRoute>> getStudentList() async {
    try {
      final response = await dio.get('${Api.studentBusRouteUrl}$id',
          options: Options(headers: {HttpHeaders.authorizationHeader: 'token $token'}));
      final data = (response.data['navigation']['data'] as List)
          .map((e) => StudentBusRoute.fromJson(e))
          .toList();
      print('success');
      return data;
    } on DioException catch (err) {
      print(err.response);
      throw Exception('Unable to fetch data');
    }
  }
}


class BusLocationService{
  String token;

  BusLocationService(this.token);

  final dio = Dio();

  Future<List<BusLocation>> getLocationInfo() async {
    try {
      final response = await dio.get('${Api.busLocationUrl}',
          options: Options(headers: {HttpHeaders.authorizationHeader: 'token $token'}));
      final data = (response.data['navigation']['data'] as List)
          .map((e) => BusLocation.fromJson(e))
          .toList();
      print('success');
      return data;
    } on DioError catch (err) {
      print(err.response);
      throw Exception('Unable to fetch data');
    }
  }

  Future<Either<String, dynamic>> addBusLocation({
    required int bus,
    required double latitude,
    required double longitude
  }) async {


    print("ASasdsadasdas");
    try {
      final response = await dio.post(Api.busLocationUrl,
          data: {
            'bus':bus,
            'latitude':latitude,
            'longitude':longitude

          },
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $token'}));
      return Right(response.data);
    } on DioException catch (err) {
      print(err.response);
      throw Exception('$err');
    }
  }

  Future<Either<String, dynamic>> updateBusLocation({
    required int id,
    required int bus,
    required double latitude,
    required double longitude
  }) async {
    try {
      final response = await dio.patch('${Api.updateBusLocationUrl}$id/',
          data: {
            'bus':bus,
            'latitude':latitude,
            'longitude':longitude

          },
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'token $token'}));
      return Right(response.data);
    } on DioException catch (err) {
      print(err.response);
      throw Exception('Network error');
    }
  }

}