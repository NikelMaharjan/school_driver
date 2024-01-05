import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../main.dart';
import '../model/auth_state.dart';
import '../model/user.dart';
import '../services/auth_service.dart';



final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final userBox = ref.watch(box);

  return AuthNotifier(AuthState(
      errorMessage: '',
      isLoad: false,
      isSuccess: false,
      user:
      userBox == null ? User.empty() : User.fromJson(jsonDecode(userBox))));
});


class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(AuthState state) : super(state);


  Future<void> userLogin(
      {required String email, required String password}) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response =
    await AuthService.userLogin(email: email, password: password);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(
          isLoad: false, errorMessage: '', isSuccess: true, user: r);
    });
  }

  Future<void> userLogout(String token) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await AuthService.userLogout(token);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (_) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true,user: User.empty());
    });
  }


}