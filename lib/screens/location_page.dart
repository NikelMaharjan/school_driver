import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  double lat = 0.0;
  double long = 0.0;

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStreamSubscription;

  Set<Marker> marker = {};

  @override
  void initState() {
    super.initState();
    delayedBuild();
    locationStream();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> delayedBuild() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  Future<void> locationStream() async {



    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.medium,
        // distanceFilter: 10
      ),
    ).listen((Position position) async {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    print("latitude is $lat and $long");

    return Scaffold(
      appBar: AppBar(
        title: Text('Location Page'),
      ),
      body: lat == 0.0 && long == 0.0 ? Center(
        child: CircularProgressIndicator(),
      )
          : Center(
           child: GoogleMap(
           onMapCreated: (controller) {
            setState(() {
              _mapController = controller;
            });
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(lat ?? 0, long ?? 0),
            zoom: 15,
          ),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          compassEnabled: true,
        ),
      ),
    );
  }
}