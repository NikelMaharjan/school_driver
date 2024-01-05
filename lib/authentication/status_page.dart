import 'package:driver/screens/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/auth_provider.dart';
import 'login_page.dart';

class StatusPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    print('token : ${auth.user.token}');
    print('userInfo : ${auth.user.userInfo.userType}');


    return auth.user.token.isNotEmpty || auth.user.userInfo.userType == 'Driver'
        ? DriverPage()
        : LoginPage();
  }
}
