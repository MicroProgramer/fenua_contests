import 'package:fenua_contests/models/user_credentials.dart';

class UserInfo {
  String first_name, last_name, nickname;
  int age;
  String city;
  bool checked_0, checked_1, checked_2;

  UserInfo({
    required this.first_name,
    required this.last_name,
    required this.nickname,
    required this.age,
    required this.city,
    required this.checked_0,
    required this.checked_1,
    required this.checked_2,
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': this.first_name,
      'last_name': this.last_name,
      'nickname': this.nickname,
      'age': this.age,
      'city': this.city,
      'checked_0': this.checked_0,
      'checked_1': this.checked_1,
      'checked_2': this.checked_2,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      first_name: map['first_name'] as String,
      last_name: map['last_name'] as String,
      nickname: map['nickname'] as String,
      age: map['age'] as int,
      city: map['city'] as String,
      checked_0: map['checked_0'] as bool,
      checked_1: map['checked_1'] as bool,
      checked_2: map['checked_2'] as bool,
    );
  }
}