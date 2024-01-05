import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:driver/authentication/login_page.dart';
import 'package:driver/constants/snack_show.dart';
import 'package:driver/providers/attendance_provider.dart';
import 'package:driver/students.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/colors.dart';
import '../../api.dart';
import '../model/bus_model.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../services/driver_service.dart';
import 'location_page.dart';

class DriverPage extends ConsumerStatefulWidget {
  const DriverPage({super.key});

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends ConsumerState<DriverPage> {

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
  void initState() {
    super.initState();
    _requestPermission();




  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    final permission = await Geolocator.requestPermission();

    setState(() {
      _permission = permission;
    });
    await Geolocator.getCurrentPosition();
  }

  void _openLocationSettings() async {
    await Geolocator.openAppSettings();
  }

  void _refreshPage() {
    setState(() {
      _requestPermission();
    });
  }



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
        SnackShow.showSuccess(context, 'Successfully Added');
        Get.back();

      }
    });

    List<StudentBusRoute> studDataList = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver's Page"),
        actions: [
          IconButton(
              onPressed: () async {
                // Get.to(()=>BusLocationUpdate());
                // // Get.to(()=>LocationPage());
                await ref
                    .read(authProvider.notifier)
                    .userLogout(auth.user!.token);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
        backgroundColor: primary, // set the primary color to blue
      ),
      backgroundColor: Colors.white, // set the scaffold background to white
      body: infoData.when(
          data: (data) {


            final studentList = ref.watch(studentBusProvider(data.first.id));




            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Card(
                          elevation: 0,
                          color: Colors.grey.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: SizedBox(
                            height: 90.h,
                            width: 350.w,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                              title: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.h, horizontal: 8.w),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.sp,
                                      backgroundImage: NetworkImage(
                                          '${Api.basePicUrl}${data.first.bus.driver.employeePhoto}'),
                                    ),
                                    SizedBox(width: 15.w),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          data.first.bus.driver.employeeName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 255.w,
                                          // color: Colors.red,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Bus no: ${data.first.bus.busNumber}',
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 15.sp),
                                                  ),
                                                  Text(
                                                    'Bus Route: ${data.first.route.routeName}',
                                                    style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 15.sp),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Card(
                          elevation: 0,
                          color: isSwitched == true ? pre_color : Colors.grey.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: SizedBox(
                            height: 120.h,
                            width: 350.w,
                            child: _permission == LocationPermission.deniedForever ? ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                              title: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Please give permission to access location from settings.',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: isSwitched == true
                                                ? Colors.white
                                                : Colors.black)),
                                    ElevatedButton(
                                      onPressed: _openLocationSettings,
                                      child: const Text('Open Location Settings'),
                                    ),
                                  ],
                                ),
                              ),
                            ) : _permission == LocationPermission.denied
                                ? ListTile(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 0.h),
                              title: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Please give permission to access location.',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: isSwitched == true
                                                ? Colors.white
                                                : Colors.black)),
                                    ElevatedButton(
                                      onPressed: _requestPermission,
                                      child: const Text('Grant Permission'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : ListTile(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 0.h),
                              title: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Enable tracking',
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              color: isSwitched == true ? Colors.white : Colors.black),
                                        ),
                                        Switch(
                                          value: isSwitched,
                                          onChanged: (value) {
                                            setState(() {
                                              isSwitched = value;
                                            });
                                            _startTimer(isSwitched);
                                          },
                                          activeTrackColor: Colors.white.withOpacity(0.5),
                                          activeColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                    if (isSwitched == true)
                                      TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: isSwitched == true ? Colors.white : primary,
                                              foregroundColor: isSwitched == true ? primary : Colors.red,
                                              fixedSize: Size.fromWidth(320.w),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  side: const BorderSide(color: Colors.black,))),
                                          onPressed: () {
                                            Get.to(() => LocationPage());
                                            },
                                          child: Text(
                                            'Show on map',
                                            style: TextStyle(
                                                fontSize: 15.sp),
                                          ))
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Card(
                          elevation: 0,
                          color: Colors.grey.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(

                            onTap: (){
                              Get.to(() => StudentList());
                            },

                            title: const Text("Take Attendance", style: TextStyle(color: Colors.black),),
                            trailing: const Icon(Icons.forward, color: Colors.black,),

                          )
                      ),
                    ),




                    // SizedBox(height : 10.h),
                    //
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('Students',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.sp),),
                    //     Text('Attendance',style: TextStyle(color: Colors.black,fontSize: 15.sp),),
                    //   ],
                    // ),
                    //
                    // Divider(
                    //   color: Colors.black,
                    //   thickness: 1,
                    //
                    // ),
                    //
                    //
                    //
                    // studentList.when(
                    //     data: (stud_data){
                    //       studDataList = stud_data; // Assign stud_data to studDataList
                    //       for (int i = 0; i < stud_data.length; i++) {
                    //         checkedList.add(false);
                    //       }
                    //       return ListView.builder(
                    //           padding: EdgeInsets.zero,
                    //           itemCount: stud_data.length,
                    //           shrinkWrap: true,
                    //           physics: NeverScrollableScrollPhysics(),
                    //           itemBuilder: (context,index){
                    //             return Container(
                    //               decoration: BoxDecoration(
                    //                   border: BorderDirectional(
                    //                       top: BorderSide.none,
                    //                       start: BorderSide.none,
                    //                       end: BorderSide.none,
                    //                       bottom: BorderSide(
                    //                           color: Colors.black
                    //                       )
                    //                   )
                    //               ),
                    //               child: ListTile(
                    //                 onTap: (){
                    //                   Get.to(AttendanceStatus(student_id: stud_data[index].id,));
                    //                 },
                    //                 leading: CircleAvatar(
                    //                   backgroundImage: NetworkImage('${Api.basePicUrl}${stud_data[index].student.studentPhoto}'),
                    //                 ),
                    //                 title: Text(stud_data[index].student.studentName,style: TextStyle(color: Colors.black),),
                    //                 trailing: Checkbox(
                    //                   side: BorderSide(
                    //                     color: Colors.black
                    //                   ),
                    //                   value: checkedList[index],
                    //                   onChanged: (value) {
                    //                     setState(() {
                    //                       checkedList[index] = value!;
                    //                     });
                    //                   },
                    //                 ),
                    //               ),
                    //             );
                    //           }
                    //       );
                    //     },
                    //     error: (err,stack)=>Center(child: Text('$err',style: TextStyle(color: Colors.black),)),
                    //     loading: ()=> Center(child: CircularProgressIndicator())
                    // )

                  ],
                ),
              ),
            );
          },
          error: (err, stack) => Center(
              child: Text(
                '$err',
                style: const TextStyle(color: Colors.black),
              )),
          loading: () => const Center(child: CircularProgressIndicator(),)),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: pre_color,
      //   onPressed: ()async{
      //     showDialog(
      //
      //         context: context,
      //         builder: (context){
      //           return AlertDialog(
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.all(Radius.circular(10.0))
      //             ),
      //             backgroundColor: Colors.white,
      //             content: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text('${dateTime}',style: TextStyle(color: Colors.black),),
      //                 Divider(
      //                   thickness: 1,
      //                   height: 8.h,
      //                   color: Colors.black,
      //                 ),
      //                 Text('Submit today\'s attendance?',style: TextStyle(color: Colors.black),),
      //               ],
      //             ),
      //             actions: [
      //               ElevatedButton(
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: primary
      //                 ),
      //                   onPressed: attendData.isLoad ? null : (){
      //                     for (int index = 0; index < studDataList.length; index++) {
      //                       String status = checkedList[index] ? 'Present' : 'Absent';
      //                       ref.read(attendanceProvider.notifier).addAttendance(
      //                         token: auth.user.token,
      //                         student: studDataList[index].id,
      //                         status: status,
      //                         date: dateTime,
      //                       );
      //                     }
      //
      //                   },
      //                   child:  Text('Confirm',style: TextStyle(color: Colors.white),)
      //               ),
      //               TextButton(
      //                   onPressed: (){
      //                     Navigator.pop(context);
      //                   },
      //                     child: Text('Cancel',style: TextStyle(color: Colors.black),)
      //               ),
      //
      //             ],
      //           );
      //         }
      //     );
      //   },
      //   child: Icon(Icons.check,color: Colors.white,),
      // ),
    );
  }


  void _updatePosition() async {

    _positionStreamSubscription = await Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high
        )
    ).listen((Position position) async {
      setState(() {
        _currentPosition = position;
      });
    });
  }


  void _startTimer(bool enabled) {

    if(enabled){

      _updatePosition();
      try{
        setState(() {
          _locationService = 1;
        });
        _timer = Timer.periodic(const Duration(seconds: 4), (_) {
          print('switch: $isSwitched');
          if (_currentPosition != null) {
            final auth = ref.read(authProvider);
            final infoData = ref.watch(busInfo(auth.user.token));
            final locationData = ref.watch(locationInfo(auth.user.token));

            infoData.when(
              data: (infoData) async{
                try{
                  final response = await Dio().get('${Api.busLocationUrl}',
                      options: Options(headers: {HttpHeaders.authorizationHeader: 'token ${auth.user.token}'}));
                  if(response.statusCode == 200){
                    print('There is data');
                    final data = (response.data['navigation']['data']as List).map((e) => BusLocation.fromJson(e)) .toList();
                    if (data.any((bus) => bus.bus == infoData.first.bus.id)) {
                      print('Data exists');
                      print(data.map((e) => e.id).join('.'));
                      ref.watch(locationProvider.notifier).updateLocation(
                          token: auth.user.token,
                          id: int.parse(data.map((e) => e.id).join('.')),
                          bus: infoData.first.bus.id,
                          latitude: _currentPosition?.latitude??0.0,
                          longitude: _currentPosition?.longitude??0.0
                      );
                    }
                    else {
                      print('No data found');
                      ref.watch(locationProvider.notifier).addLocation(
                          token: auth.user.token,
                          bus: infoData.first.bus.id,
                          latitude: _currentPosition?.latitude??0.0,
                          longitude: _currentPosition?.longitude??0.0
                      );
                    }
                  }

                  else if(response.statusCode == 204){
                    print('No Data');
                    ref.watch(locationProvider.notifier).addLocation(
                        token: auth.user.token,
                        bus: infoData.first.bus.id,
                        latitude: _currentPosition?.latitude??0.0,
                        longitude: _currentPosition?.longitude??0.0
                    );
                  }
                  else{
                    print('Unknown error');
                  }
                }on DioException catch (err) {
                  print(err.response);
                  throw Exception('Unable to fetch data');
                }

              },
              error: (err, stack) =>
                  print('Error: $err'), // Handle infoData error
              loading: () => print('Info data is still loading'), // Handle loading state
            );
          }
        });
      }catch (error) {
        if (error is PlatformException && error.code == 'PERMISSION_DENIED') {
          setState(() {
            _locationService=2;
          });
          print("Location permission denied.");
        }
        else {
          setState(() {

            _locationService = 2;
            isSwitched = false;
          });
          print("Error retrieving location: $error");
        }

      }
    }

    else{
      _positionStreamSubscription?.cancel();
      _timer?.cancel();
    }



  }

}