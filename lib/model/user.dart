class User {
  final String token;
  final UserInfo userInfo;

  User({required this.token, required this.userInfo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      userInfo: UserInfo.fromJson(json['user_info']),
    );
  }

  factory User.empty() {
    return User(token: '', userInfo: UserInfo.empty());
  }
}

class UserInfo {
  final String email;
  final SchoolCollege school_college;
  final String userType;
  final String name;

  UserInfo({required this.email, required this.school_college, required this.userType, required this.name});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      school_college: SchoolCollege.fromJson(json['school_college']),
      userType: json['userType'],
      name: json['name'],
    );
  }

  factory UserInfo.empty() {
    return UserInfo(
      school_college: SchoolCollege(
        id: 1,
        name: "",
        school_type: "",
        ward: 1,
        cover_photo: "",
        principal_name: "",
        short_name: "",
        status: "",
        established_date: "",
        logo: "",
      ),
      email: '',
      userType: '',
      name: '',
    );
  }
}

class SchoolCollege {

  final int id;
  final String name;
  final String short_name;
  final String logo;
  final String school_type;
  final String cover_photo;
  final String established_date;
  final String principal_name;
  final String status;
  final int ward;


  SchoolCollege({

    required this.id,
    required this.name,
    required this.school_type,
    required this.ward,
    required this.cover_photo,
    required this.principal_name,
    required this.short_name,
    required this.status,
    required this.established_date,
    required this.logo
  });

  factory SchoolCollege.fromJson (Map<String, dynamic> json){
    return SchoolCollege(
        id: json['id'],
        name: json['name'],
        school_type: json['school_type'],
        ward: json['ward'],
        cover_photo: json['cover_photo'],
        principal_name: json['principal_name'],
        short_name: json['short_name'],
        status: json['status'],
        established_date: json['established_date'],
        logo: json['logo']
    );
  }





}