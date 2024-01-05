

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/crud_state.dart';
import '../services/driver_service.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, CrudState>((ref) => LocationNotifier(CrudState.empty()));



class LocationNotifier extends StateNotifier<CrudState>{
  LocationNotifier(super.state);

  Future<void> addLocation({
    required String token,
    required int bus,
    required double latitude,
    required double longitude,

  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await BusLocationService(token).addBusLocation(
        bus: bus,
        latitude: latitude,
        longitude: longitude);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(
          isLoad: false, errorMessage: '', isSuccess: true);

    });
  }

  Future<void> updateLocation({
    required String token,
    required int id,
    required int bus,
    required double latitude,
    required double longitude

  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await BusLocationService(token).updateBusLocation(
        id: id,
        bus: bus,
        latitude: latitude,
        longitude: longitude);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }



}