
import 'package:driver/authentication/status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../constants/snack_show.dart';
import '../providers/auth_provider.dart';






class LoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginPage> createState() => _Teacher_loginState();
}

class _Teacher_loginState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _obscureText = true;

  double boxX = -1;
  double boxX1 = 1;
  double boxY = 10;
  double boxY1 = -10;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Rebuild the screen after 3s which will process the animation from green to blue
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      if(mounted){

        setState(() {
          boxX = -1;
          boxY = 1;
          boxX1 = 1;
          boxY1 = -1;
        });


      }

    });
    Future.delayed(Duration(seconds: 1)).then((value) {
      if(mounted){

        setState(() {
          _visible = !_visible;

        });

      }

    });


  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty ) {
        SnackShow.showFailure(context, next.errorMessage);
      }

      else if (next.isSuccess){
        SnackShow.showSuccess(context, 'Successfully login');
      }
    });

    final authNotifier = ref.watch(authProvider.notifier);
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 700),
            alignment: Alignment(boxX, boxY),
            curve: Curves.bounceIn,
            child: Container(
              height: 150.h,
              width: 300.w,
              child: Image.asset(
                'assets/images/bottom.jpg',
                fit: BoxFit.fill,
                opacity: const AlwaysStoppedAnimation(.5),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 700),
            alignment: Alignment(boxX1, boxY1),
            curve: Curves.bounceIn,
            child: Container(
              height: 150.h,
              width: 300.w,
              child: Image.asset(
                'assets/images/top.jpg',
                fit: BoxFit.fill,
                opacity: const AlwaysStoppedAnimation(.5),
              ),
            ),
          ),
          AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 700),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                width: 350.0,
                height: 550.0,
                // color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Text(
                        'Let\'s Sign In',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Welcome Back,',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.sp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Text(
                        'You\'ve been missed!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.sp,
                        ),
                      ),
                    ),
                    Form(
                        key: _form,
                        child: Column(
                          children: [
                            Container(
                              width: 350,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 18.h),
                                    child: TextFormField(
                                        controller: emailController,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'email is  required';
                                          } else if (!val.contains('@')) {
                                            return 'please enter valid email';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.sp),
                                        decoration: InputDecoration(
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            prefixIcon: Icon(
                                              Icons.person,
                                              color: Colors.black,
                                            ),

                                            // fillColor: Colors.black,
                                            // filled: true,
                                            hintText: 'E-mail',
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.sp))),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: TextFormField(
                                        controller: passwordController,
                                        obscureText: _obscureText,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'password is  required';
                                          } else if (val.length > 20) {
                                            return 'maximum character exceeded';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.sp),
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                  _obscureText
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.black),
                                              onPressed: () {
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                            ),
                                            contentPadding:
                                            EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Colors.black,
                                            ),

                                            // fillColor: Colors.black,
                                            // filled: true,
                                            hintText: 'Password',
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.sp))),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                        onTap: () {
                                          SnackShow.showFailure(context, 'Coming soon');
                                        },
                                        child: Padding(
                                          padding:
                                          EdgeInsets.only(bottom: 20.h),
                                          child: Text(
                                            'Reset password?',
                                            style:
                                            TextStyle(color: Colors.blue),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 8.w),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: primary,
                                          foregroundColor: Colors.white,
                                          fixedSize: Size.fromWidth(320.w),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: Colors.black,
                                              ))),
                                      onPressed: () {
                                        if (_form.currentState!.validate()) {
                                          authNotifier.userLogin(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          ).then((value){
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => StatusPage(),
                                              ),
                                            );
                                          });



                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.h, horizontal: 8.w),
                                        child: auth.isLoad?CircularProgressIndicator(): Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}