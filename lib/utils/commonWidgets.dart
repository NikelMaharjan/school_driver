
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/colors.dart';



enum ConnectivityStatus { Connected, Disconnected, Unknown }



class InfoTileWidget extends StatelessWidget {
  final String title;
  final String? svgPath;
  final VoidCallback onTap;

  InfoTileWidget({
    required this.title,
    this.svgPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          onTap: onTap,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color(0xffbbedd7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: svgPath != null? Center(
                      child: SvgPicture.asset(
                        svgPath!,
                        width: 40,
                        height: 40,
                        theme: SvgTheme(
                          currentColor: Colors.black,
                        ),
                      ),
                    ): SizedBox(),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}






class CommonCard extends StatelessWidget {
  final String time;
  final String? className;
  final String subjectName;
  final String? svgAsset;
  final String? svgPath;
  final VoidCallback? onTap;
  final String? day;

  const CommonCard({
    Key? key,
    required this.time,
    this.className,
    required this.subjectName,
    this.svgAsset,
    this.svgPath,
    this.onTap,
    this.day
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        height: 80.h,
        child: Card(
          shadowColor: Colors.black26,
          color: Colors.white,
          elevation: 7,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                  height: 70.h,
                  width: 70.w,
                  child: svgAsset != null
                      ? SvgPicture.asset(svgAsset!,)
                      : svgPath != null
                      ? SvgPicture.network(svgPath!,)
                      : null,
                ),
                Expanded(
                  child: ListTile(
                    onTap: onTap,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        className==null?
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              className!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          subjectName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







class CommonTextButton extends ConsumerWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CommonTextButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context,ref) {

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}



class NoInternetDialog extends StatelessWidget {
  final Function() onTryAgain;

  const NoInternetDialog({Key? key, required this.onTryAgain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 290,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/jsons/no_internet.json',
              fit: BoxFit.contain,
            ),
            Text(
              'No internet connection',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          onPressed: onTryAgain,
          child: const Text('Try Again'),
        ),
      ],
    );
  }
}

class NoticeCard extends StatelessWidget {
  final String title;
  final String description;
  final String createdAt;


  const NoticeCard({
    required this.title,
    required this.description,
    required this.createdAt,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(5),
            side: BorderSide(

                color: Colors.black
            )
        ),
        child: ListTile(
          onTap: (){
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
                    content: Container(
                      child:Text(
                        description,
                        style: TextStyle(color: Colors.black),
                        maxLines: null,
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          createdAt,
                          style: TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                      )
                    ],
                    actionsAlignment: MainAxisAlignment.start,
                  );
                }
            );
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.45,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ) ,
              ),
              Text(
                '${DateFormat('yyyy-MM-dd').format(DateTime.parse(createdAt))}',
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              )
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Container(
              width: MediaQuery.of(context).size.width*0.6,
              child: Text(
                description,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoticeCard2 extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final String createdAt;

  const NoticeCard2({
    this.onLongPress,
    required this.title,
    this.onTap,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.h),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(5),
            side: BorderSide(

                color: Colors.black
            )
        ),
        child: ListTile(
          onLongPress: onLongPress,
          onTap: onTap,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width *0.6,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),

            ],
          ),
          subtitle: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                createdAt,
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              )
          ),
          trailing: Icon(Icons.arrow_circle_right_rounded,color: Colors.black,),
        ),
      ),
    );
  }
}

class NoticeCard3 extends StatelessWidget {
  final String title;
  final String description;
  final String createdAt;
  final String? image;


  const NoticeCard3({
    required this.title,
    required this.description,
    required this.createdAt,
    this.image

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(5),
            side: BorderSide(

                color: Colors.black
            )
        ),
        child: ListTile(
          onTap: (){
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
                    content: Container(
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              description,
                              style: TextStyle(color: Colors.black),
                              maxLines: null,
                            ),
                          ),
                          SizedBox(height: 5.h,),
                          if(image!=null)
                            Container(
                              height: MediaQuery.of(context).size.height*0.2,
                              child: Image.network(image!,fit: BoxFit.contain,),
                            )
                        ],
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          createdAt,
                          style: TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                      )
                    ],
                    actionsAlignment: MainAxisAlignment.start,
                  );
                }
            );
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.6,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ) ,
              ),
              Text(
                createdAt,
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              )
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Container(
              width: MediaQuery.of(context).size.width*0.6,
              child: Text(
                description,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final String date;

  const ExamCard({
    this.onLongPress,
    required this.title,
    this.onTap,
    required this.date,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(5),
            side: BorderSide(

                color: Colors.black
            )
        ),

        child: ListTile(
          onLongPress: onLongPress,
          onTap: onTap,
          title: Container(
            width: MediaQuery.of(context).size.width *0.6,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          subtitle: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                date,
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              )
          ),
          trailing: Icon(Icons.arrow_circle_right_rounded,color: Colors.black,),
        ),
      ),
    );
  }
}

class CommonCard2 extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;




  const CommonCard2({

    required this.title,
    this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.h),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(5),
            side: BorderSide(

                color: Colors.black
            )
        ),
        child: ListTile(

          onTap: onTap,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width *0.6,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),

            ],
          ),
          trailing: Icon(Icons.arrow_circle_right_rounded,color: Colors.black,),
        ),
      ),
    );
  }
}

class IconTextRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback? onTap;

  const IconTextRow({Key? key,this.onTap,required this.title, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: primary, // you can customize the color here
            ),
            child: Icon(
              icon,
              size: 35.sp,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
              ),
              Text(
                text, // replace this with your variable
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
              ),
            ],
          )
        ],
      ),
    );
  }
}









//loading ...


class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 5, // This is the number of shimmer placeholders to show
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                leading: Container(
                  height: 60.h,
                  width: 80.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: shimmerContentColor,
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Container(
                    height: 10.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:shimmerContentColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShimmerListTile2 extends StatelessWidget {
  const ShimmerListTile2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        itemCount: 3, // This is the number of shimmer placeholders to show
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),

                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Container(
                    height: 80.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:shimmerContentColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShimmerListTile3 extends StatelessWidget {
  const ShimmerListTile3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        itemCount: 1, // This is the number of shimmer placeholders to show
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Card(
              elevation: 8,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),

                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Container(
                    height: 50.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:shimmerContentColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class GridShimmer extends StatelessWidget {
  const GridShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 4, // the number of grid tiles to show in the loading state
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2.w / 1.3.h,
        crossAxisCount: 2,
        mainAxisSpacing: 5.h,
        crossAxisSpacing: 3.w,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            Shimmer.fromColors(
              baseColor: shimmerBaseColor,
              highlightColor: shimmerHighlightColor,
              child: Container(
                height: 80.h,
                width: 150.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: shimmerContentColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CircularShimmer extends StatelessWidget {
  const CircularShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: CircleAvatar(
              backgroundColor: shimmerContentColor,
              radius: 30.sp,
            ),
          ),
          SizedBox(width: 10.w,),
          Container(
            height: 18.sp,
            width: 130.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: shimmerContentColor,
            ),
          ),

        ],
      ),
    );
  }
}

class NoticeShimmer extends StatelessWidget {
  const NoticeShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 5, // You can set the number of shimmer items you want to show
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
        child: Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            elevation: 0,
            color: shimmerContentColor,
            child: ListTile(
              title: Container(
                height: 12.sp,
                color: shimmerContentColor, // Shimmer base color
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 8.sp,
                      width: double.infinity,
                      color: shimmerContentColor, // Shimmer base color
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 8.sp,
                      width: 50.w,
                      color: shimmerContentColor, // Shimmer base color
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}





