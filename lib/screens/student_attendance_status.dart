



import 'package:driver/services/attendance_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../../constants/colors.dart';
import '../../../../../utils/commonWidgets.dart';

class AttendanceStatus extends ConsumerStatefulWidget {

  final int student_id;
  AttendanceStatus({required this.student_id});

  @override
  ConsumerState<AttendanceStatus> createState() => _AttendanceStatusState();
}

class _AttendanceStatusState extends ConsumerState<AttendanceStatus> {

  @override
  void initState(){
    super.initState();
    ref.invalidate(studentAttendanceInfo(widget.student_id));
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final attendStatus = ref.watch(studentAttendanceInfo(widget.student_id));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("STATUS", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            // color: Colors.red,
              height: MediaQuery.of(context).size.height*4.2/5,
              child:  attendStatus.when(
                data: (data){
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        shape: Border.all(
                            color: Colors.black
                        ),
                        child: ListTile(
                          title: Text(data[index].date,style: const TextStyle(color: Colors.black),),
                          trailing: CircleAvatar(
                            radius: 10.sp,
                            backgroundColor: data[index].status == 'Present' ? pre_color: abs_color,
                          ),
                        ),
                      );

                    },
                  );

                },
                error: (err, stack) => Center(child: Text('$err', style: const TextStyle(color: Colors.black),)),
                loading: () => const NoticeShimmer(),
              )



          )
        ],
      ),
    );
  }
}