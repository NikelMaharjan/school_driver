import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:driver/constants/snack_show.dart';
import 'package:driver/providers/attendance_provider.dart';
import 'package:driver/screens/student_attendance_status.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/colors.dart';
import '../../api.dart';
import '../model/bus_model.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../services/driver_service.dart';
import '../utils/commonWidgets.dart';

class StudentList extends ConsumerStatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends ConsumerState<StudentList> {

  bool isSwitched = false;
  int? _locationService;
  int switchCase =0;
  int locationId = 0;
  Timer? _timer;
  Position? _currentPosition;
  double lat = 0.0;
  double long = 0.0;


  // Add variables to hold the current position and location services status

  StreamSubscription<Position>? _positionStreamSubscription;
  LocationPermission _permission = LocationPermission.denied;
  List<bool> checkedList = [];


  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final infoData = ref.watch(busInfo(auth.user.token));
    final locationData = ref.watch(locationInfo(auth.user.token));
    final attendData = ref.watch(attendanceProvider);
    final DateTime now = DateTime.now();
    final String dateTime = DateFormat('yyyy-MM-dd').format(now);



    ref.listen(attendanceProvider, (previous, next) {
      if(next.errorMessage.isNotEmpty){
        SnackShow.showFailure(context, next.errorMessage);
      }else if(next.isSuccess){
        SnackShow.showSuccess(context, 'Successfully Added Attendance');
        Get.back();

      }
    });

    List<StudentBusRoute> studDataList = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Page"),
        backgroundColor: primary, // set the primary color to blue
      ),
      backgroundColor: Colors.white, // set the scaffold background to white
      body: infoData.when(
          data: (data) {


            final studentList = ref.watch(studentBusProvider(data.first.id));




            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [





                  Expanded(
                    child: studentList.when(
                        data: (stud_data){
                          studDataList = stud_data; // Assign stud_data to studDataList
                          for (int i = 0; i < stud_data.length; i++) {
                            checkedList.add(false);
                          }
                          return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: stud_data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                                return Container(
                                  decoration: const BoxDecoration(
                                      border: BorderDirectional(
                                          top: BorderSide.none,
                                          start: BorderSide.none,
                                          end: BorderSide.none,
                                          bottom: BorderSide(
                                              color: Colors.black
                                          )
                                      )
                                  ),
                                  child: ListTile(
                                    onTap: (){
                                      Get.to(AttendanceStatus(student_id: stud_data[index].id,));
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage('${Api.basePicUrl}${stud_data[index].student.studentPhoto}'),
                                    ),
                                    title: Text(stud_data[index].student.studentName,style: const TextStyle(color: Colors.black),),
                                    trailing: Checkbox(
                                      side: const BorderSide(
                                          color: Colors.black
                                      ),
                                      value: checkedList[index],
                                      onChanged: (value) {
                                        setState(() {
                                          checkedList[index] = value!;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        error: (err,stack)=>Center(child: Text('$err',style: const TextStyle(color: Colors.black),)),
                        loading: ()=> const Center(child: CircularProgressIndicator())
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                        ),
                        onPressed: attendData.isLoad ? null : (){
                          for (int index = 0; index < studDataList.length; index++) {
                            String status = checkedList[index] ? 'Present' : 'Absent';
                            ref.read(attendanceProvider.notifier).addAttendance(
                              token: auth.user.token,
                              student: studDataList[index].id,
                              status: status,
                              date: dateTime,
                            );
                          }

                        },
                        child:  Text('TAKE ATTENDANCE $dateTime',style:  TextStyle(color:  attendData.isLoad ? Colors.black : Colors.white),)
                    ),
                  ),

                ],
              ),
            );
          },
          error: (err, stack) => Center(
              child: Text(
                '$err',
                style: const TextStyle(color: Colors.black),
              )),
          loading: () => const Center(child: CircularProgressIndicator(),)),
    );
  }



}