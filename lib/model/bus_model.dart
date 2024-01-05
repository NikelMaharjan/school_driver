class BusRouteAssignment {
  int id;
  Bus bus;
  Route route;
  String startTime;
  String endTime;

  BusRouteAssignment({
    required this.id,
    required this.bus,
    required this.route,
    required this.startTime,
    required this.endTime,
  });

  factory BusRouteAssignment.fromJson(Map<String, dynamic> json) {
    return BusRouteAssignment(
      id: json['id'],
      bus: Bus.fromJson(json['bus']),
      route: Route.fromJson(json['route']),
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}

class Bus {
  int id;
  Driver driver;
  String busNumber;
  int busCapacity;
  String busModel;

  Bus({
    required this.id,
    required this.driver,
    required this.busNumber,
    required this.busCapacity,
    required this.busModel,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      driver: Driver.fromJson(json['driver']),
      busNumber: json['bus_number'],
      busCapacity: json['bus_capacity'],
      busModel: json['bus_model'],
    );
  }
}

class Driver {
  int id;
  String employeeName;
  String employeePhoto;

  Driver({
    required this.id,
    required this.employeeName,
    required this.employeePhoto,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      employeeName: json['employee_name'],
      employeePhoto: json['employee_photo'],
    );
  }
}

class Route {
  int id;
  String routeName;
  String description;
  String startPoint;
  String endPoint;

  Route({
    required this.id,
    required this.routeName,
    required this.description,
    required this.startPoint,
    required this.endPoint,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      routeName: json['route_name'],
      description: json['description'],
      startPoint: json['start_point'],
      endPoint: json['end_point'],
    );
  }
}


class StudentBusRoute {
  int id;
  Student student;
  String createdAt;
  String updatedAt;
  BusRouteAssignment busRoute;

  StudentBusRoute({
    required this.id,
    required this.student,
    required this.createdAt,
    required this.updatedAt,
    required this.busRoute,
  });

  factory StudentBusRoute.fromJson(Map<String, dynamic> json) {
    return StudentBusRoute(
      id: json['id'],
      student: Student.fromJson(json['student']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      busRoute: BusRouteAssignment.fromJson(json['bus_route']),
    );
  }
}

class Student {
  int id;
  String studentName;
  String studentPhoto;

  Student({
    required this.id,
    required this.studentName,
    required this.studentPhoto,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      studentName: json['student_name'],
      studentPhoto: json['student_photo'],
    );
  }
}


class BusLocation {

  final int id;
  final double latitude;
  final double longitude;
  final int bus;

  BusLocation({
    required this.id,
    required this.bus,
    required this.longitude,
    required this.latitude
  });

  factory BusLocation.fromJson(Map<String, dynamic> json){
    return BusLocation(
        id: json['id'],
        bus: json['bus'],
        longitude: json['longitude'],
        latitude: json['latitude']);
  }

}
